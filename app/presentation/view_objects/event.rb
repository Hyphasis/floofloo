# frozen_string_literal: true

module Views
  # View for several event
  class Event
    def initialize(event)
      @event = event
    end

    def entity
      @event
    end

    def events
      @event.events
    end
  end
end
