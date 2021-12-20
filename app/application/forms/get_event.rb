# frozen_string_literal: true

require 'dry-validation'

module Floofloo
  module Forms
    # Get Event Form Validation
    class GetEvent < Dry::Validation::Contract
      params do
        required(:issue).filled(:string)
      end
    end
  end
end
