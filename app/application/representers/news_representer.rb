# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Floofloo
  module Representer
    # Represents essential News information for API output
    # USAGE:
    #   news = Database::NewsOrm.find(1)
    #   Representer::News.new(news).to_json
    class News < Roar::Decorator
      include Roar::JSON

      property :author
      property :title
      property :description
      property :url
      property :url_to_image
    end
  end
end
