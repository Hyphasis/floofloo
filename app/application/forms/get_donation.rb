# frozen_string_literal: true

require 'dry-validation'

module Floofloo
  module Forms
    # Get Donation Form Validation
    class GetDonation < Dry::Validation::Contract
      params do
        required(:issue).filled(:string)
        required(:event).filled(:string)
      end
    end
  end
end
