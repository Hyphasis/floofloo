# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Floofloo
  module Representer
    # Represents essential Donation information for API output
    # USAGE:
    #   donation = Database::DonationOrm.find(1)
    #   Representer::Donation.new(donation).to_json
    class Donation < Roar::Decorator
      include Roar::JSON

      property :title
      property :summary
      property :country
      property :city
      property :image_url
      property :project_url
    end
  end
end
