# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to get news from News API
    class GetRecommendation
      include Dry::Transaction

      step :find_recommendation
      step :reify_list

      private

      def find_recommendation(input)
        Gateway::Api.new(Floofloo::App.config)
          .recommendation_list(input[:news_id])
          .then do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      end

      def reify_list(recommendation_list_json)
        Representer::RecommendationList.new(OpenStruct.new) # rubocop:disable Style/OpenStructUse
          .from_json(recommendation_list_json)
          .then { |recommendation| Success(recommendation) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
