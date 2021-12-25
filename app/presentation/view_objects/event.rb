# frozen_string_literal: true

module Views
  # View for several event
  class Event
    def initialize(event)
      @event = event
      # binding.irb
    end

    def entity
      @event
    end

    def events
      @event.events
    end

    def disease
      @event.events[0].themes if @event.events.size.positive?
    end

    def rights
      @event.events[1].themes if @event.events.size > 1
    end

    def disaster
      @event.events[2].themes if @event.events.size > 2
    end

    def hunger
      @event.events[3].themes if @event.events.size > 3
    end

    def water
      @event.events[4].themes if @event.events.size > 4
    end

    def climate
      @event.events[5].themes if @event.events.size > 5
    end
  end
end
