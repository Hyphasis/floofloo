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

    def issue1_events
      @event.events[0].themes if @event.events.size.positive?
    end

    def issue2_events
      @event.events[1].themes if @event.events.size > 1
    end

    def issue3_events
      @event.events[2].themes if @event.events.size > 2
    end

    def issue4_events
      @event.events[3].themes if @event.events.size > 3
    end

    def issue5_events
      @event.events[4].themes if @event.events.size > 4
    end

    def issue6_events
      @event.events[5].themes if @event.events.size > 5
    end
  end
end
