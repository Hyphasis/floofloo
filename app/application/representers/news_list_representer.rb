# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'news_representer'

module Floofloo
  module Representer
    # Represents essential News information for API output
    # USAGE:
    #   news = Database::NewsOrm.all
    #   Representer::NewsList.new(news).to_json
    class NewsList < Roar::Decorator
      include Roar::JSON

      collection :articles, extend: Representer::News
    end
  end
end
