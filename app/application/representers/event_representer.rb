# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Floofloo
  module Representer
    # Represents essential Event information for API output
    # USAGE:
    #   news = Database::EventOrm.find(1)
    #   Representer::Event.new(event).to_json
    class Event < Roar::Decorator
      include Roar::JSON

      property :id
      property :name
    end
  end
end
