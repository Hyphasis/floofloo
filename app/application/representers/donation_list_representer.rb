# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'donation_representer'

module Floofloo
  module Representer
    # Represents essential Donation information for API output
    # USAGE:
    #   donation = Database::DonationOrm.all
    #   Representer::DonationsList.new(donation).to_json
    class DonationsList < Roar::Decorator
      include Roar::JSON

      collection :donations, extend: Representer::Donation
    end
  end
end
