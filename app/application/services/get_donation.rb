# frozen_string_literal: true

require 'dry/transaction'

module Floofloo
  module Services
    # Transaction to get news from News API
    class GetDonation
      include Dry::Transaction

      step :find_donations
      step :reify_list

      private

      def find_donations(input)
        Gateway::Api.new(Floofloo::App.config)
          .donations_list(input[:issue], input[:event])
          .then do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      end

      def reify_list(donation_list_json)
        Representer::DonationsList.new(OpenStruct.new)
          .from_json(donation_list_json)
          .then { |donation| Success(donation) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
