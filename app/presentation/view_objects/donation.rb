# frozen_string_literal: true

module Views
  # View for several news
  class Donation
    def initialize(donation)
      @donation = donation
    end

    def entity
      @donation
    end

    def projects
      @donation.donations
    end
  end
end
