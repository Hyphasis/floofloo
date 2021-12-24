# frozen_string_literal: true

module Views
  # View for several recommendations
  class Recommenation
    def initialize(recommendation)
      @recommendation = recommendation
    end

    def entity
      @news
    end

    def articles
      @recommendation.articles
    end

    def donations
      @recommendation.donations
    end
  end
end
