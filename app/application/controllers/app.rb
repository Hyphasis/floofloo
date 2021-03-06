# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module Floofloo
  # Web App
  class App < Roda # rubocop:disable Metrics/ClassLength
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css'

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS

      # GET /
      routing.root do
        session[:event] ||= []
        events_session = session[:event]

        find_event = Services::GetEvent.new.call

        if find_event.failure?
          flash[:error] = find_event.failure
          routing.redirect '/'
        end

        event_view_object = Views::Event.new(find_event.value!)

        view 'home', locals: { events_session: events_session, events: event_view_object }
      end

      routing.on 'issue' do # rubocop:disable Metrics/BlockLength
        routing.on String do |issue_name| # rubocop:disable Metrics/BlockLength
          routing.on 'event' do # rubocop:disable Metrics/BlockLength
            routing.on String do |event_name| # rubocop:disable Metrics/BlockLength
              routing.on 'news' do
                routing.is do
                  routing.get do
                    # GET /issue/{issue_name}/event/{event_name}/news
                    routing.is do
                      result = Forms::GetNews.new.call(issue: issue_name,
                                                       event: event_name)

                      find_news = Services::GetNews.new.call(result)

                      if find_news.failure?
                        flash[:error] = find_news.failure
                        routing.redirect '/'
                      end

                      session[:event].insert(0, event_name).uniq!

                      news_view_object = Views::News.new(find_news.value!)

                      view 'news', locals: { news: news_view_object }
                    rescue StandardError => e
                      flash[:error] = 'Failed to get news!'
                      puts e.full_message

                      routing.redirect '/'
                    end
                  end
                end
              end

              routing.on 'donations' do
                # GET /issue/{issue_name}/event/{event_name}/donations
                routing.is do
                  result = Forms::GetDonation.new.call(issue: issue_name,
                                                       event: event_name)

                  find_donation = Services::GetDonation.new.call(result)

                  if find_donation.failure?
                    flash[:error] = find_donation.failure
                    routing.redirect '/'
                  end

                  session[:event].insert(0, event_name).uniq

                  donations_view_object = Views::Donation.new(find_donation.value!)

                  view 'donations', locals: { donations: donations_view_object }
                rescue StandardError => e
                  flash[:error] = 'Failed to get donations!'
                  puts e.full_message

                  routing.redirect '/'
                end
              end
            end
          end
        end
      end

      routing.on 'event' do
        # GET /event
        routing.is do
          find_event = Services::GetEvent.new.call

          if find_event.failure?
            flash[:error] = find_event.failure
            routing.redirect '/'
          end

          event_view_object = Views::Event.new(find_event.value!)

          view 'events', locals: { events: event_view_object }
        rescue StandardError => e
          flash[:error] = 'Failed to get events!'
          puts e.full_message

          routing.redirect '/'
        end
      end

      routing.on 'news' do
        routing.on String do |news_id|
          routing.get do
            find_recommendation = Services::GetRecommendation.new.call(news_id: news_id)

            if find_recommendation.failure?
              flash[:error] = find_recommendation.failure
              routing.redirect '/'
            end

            recommendation_view_object = Views::Recommenation.new(find_recommendation.value!)

            view 'recommendation', locals: { recommendation: recommendation_view_object }
          rescue StandardError => e
            flash[:error] = 'Failed to get events!'
            puts e.full_message

            routing.redirect '/'
          end
        end
      end
    end
  end
end
