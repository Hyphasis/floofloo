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

        view 'home', locals: { events_session: events_session }
      end
      routing.on 'issue' do
        routing.on String do |issue_name|
          routing.on 'event' do # rubocop:disable Metrics/BlockLength
            routing.on String do |event_name| # rubocop:disable Metrics/BlockLength
              routing.on 'news' do # rubocop:disable Metrics/BlockLength
                routing.is do # rubocop:disable Metrics/BlockLength
                  # POST /event/{event_name}/news
                  routing.post do
                    language = routing.params['language']
                    keywords = routing.params['keywords']
                    from = routing.params['from']
                    to = routing.params['to']
                    sort_by = routing.params['sort_by']

                    routing.halt 400 if keywords.nil?

                    event = Floofloo::Entity::Event.new(
                      id: nil,
                      name: event_name
                    )
                    event_result = Repository::IssuesFor.entity(event).create(event)

                    # Get news from News
                    news = News::NewsMapper
                      .new(App.config.NEWS_KEY)
                      .find(language, keywords, from, to, sort_by)
                    news_result = Repository::ArticlesFor.entity(news).create(event_result, news)

                    # Put the news on screen (Home page)
                    routing.redirect "/event/#{event_name}/news/#{news_result.id}"
                  rescue StandardError => e
                    flash[:error] = 'Failed to get news!'
                    puts e.message

                    routing.redirect '/'
                  end

                  routing.get do # rubocop:disable Metrics/BlockLength
                    # GET /event/{event_name}/news/{news_id}
                    routing.on String do |news_id|
                      news = Repository::ArticlesFor.klass(Entity::News)
                        .find_id(news_id)

                      view 'news', locals: { news: news }
                    rescue StandardError => e
                      flash[:error] = 'Failed to get news!'
                      puts e.message

                      routing.redirect '/'
                    end

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

              routing.on 'delete' do
                # GET /event/{event_name}/delete
                routing.get do
                  session[:keywords].delete(event_name)

                  events_session = session[:keywords]
                  view 'home', locals: { events_session: events_session }
                rescue StandardError => e
                  flash[:error] = 'Failed to delete event!'
                  puts e.message

                  routing.redirect '/'
                end
              end
            end
          end
        end
      end
    end
  end
end
