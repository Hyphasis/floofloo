# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'event_representer'

module Floofloo
  module Representer
    # Represents essential Event information for API output
    # USAGE:
    #   events = Database::EventOrm.all
    #   Representer::EventList.new(events).to_json
    class EventList < Roar::Decorator
      include Roar::JSON

      property :issue_id
      collection :themes, extend: Representer::Event, class: OpenStruct
    end
  end
end
