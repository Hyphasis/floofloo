# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'news_representer'

module Floofloo
  module Representer
    # Represents essential Recommendation information for API output
    # USAGE:
    #   recommendation = Database::RecommendationOrm.all
    #   Representer::RecommendationList.new(recommendation).to_json
    class RecommendationList < Roar::Decorator
      include Roar::JSON

      property :articles, extend: Representer::News, class: OpenStruct # rubocop:disable Style/OpenStructUse
      collection :donations, extend: Representer::Donation, class: OpenStruct # rubocop:disable Style/OpenStructUse
    end
  end
end
