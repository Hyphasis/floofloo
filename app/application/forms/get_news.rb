# frozen_string_literal: true

require 'dry-validation'

module Floofloo
  module Forms
    # Get News Form Validation
    class GetNews < Dry::Validation::Contract
      params do
        required(:issue).filled(:string)
        required(:event).filled(:string)
      end
    end
  end
end
