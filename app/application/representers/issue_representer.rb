# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Floofloo
  module Representer
    # Represents essential Issue information for API output
    # USAGE:
    #   news = Database::IssueOrm.find(1)
    #   Representer::Issue.new(issue).to_json
    class Issue < Roar::Decorator
      include Roar::JSON

      property :id
      property :name
    end
  end
end
