# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'event_list_representer'

module Floofloo
  module Representer
    # Represents essential Event information for API output
    # USAGE:
    #   events = Database::EventOrm.all
    #   Representer::EventList.new(events).to_json
    class EventAllList < Roar::Decorator
      include Roar::JSON

      collection :events, extend: Representer::EventList, class: OpenStruct
    end
  end
end
