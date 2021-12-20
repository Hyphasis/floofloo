# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to get news from News API
    class GetEvent
      include Dry::Transaction

      step :find_event
      step :reify_list

      private

      def find_event(input)
        Gateway::Api.new(Floofloo::App.config)
          .event_list(input[:issue])
          .then do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      end

      def reify_list(event_list_json)
        Representer::EventList.new(OpenStruct.new) # rubocop:disable Style/OpenStructUse
          .from_json(event_list_json)
          .then { |event| Success(event) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
