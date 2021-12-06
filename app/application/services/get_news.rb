# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to get news from News API
    class GetNews
      include Dry::Transaction

      step :find_news
      step :reify_list

      private

      def find_news(input)
        Gateway::Api.new(Floofloo::App.config)
          .news_list(input[:issue], input[:event])
          .then do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      end

      def reify_list(news_list_json)
        Representer::NewsList.new(OpenStruct.new)
          .from_json(news_list_json)
          .then { |news| Success(news) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
