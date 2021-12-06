# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'figaro'
require 'delegate'

module Floofloo
  # Configuration for the App
  class App < Roda
    plugin :environments

    configure do
      Figaro.application = Figaro::Application.new(
        environment: environment,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load

      def self.config() = Figaro.env

      use Rack::Session::Cookie, secret: config.SESSION_SECRET

      configure :app_test do
        require_relative '../spec/helpers/vcr_helper'
        VcrHelper.setup_vcr
        VcrHelper.configure_vct_for_news(recording: :none)
      end
    end
  end
end
