# frozen_string_literal: true

require 'http'

module Floofloo
  module Gateway
    # Infrastructure to call Floofloo API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def news_list(issue, event)
        @request.news_list(issue, event)
      end

      def donations_list(issue, event)
        @request.donation_list(issue, event)
      end

      def event_list
        @request.event_list
      end

      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = "#{config.API_HOST}/api/v1"
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def news_list(issue, event)
          call_api('get', ['issue', issue, 'event', event, 'news'])
        end

        def donation_list(issue, event)
          call_api('get', ['issue', issue, 'event', event, 'donations'])
        end

        def event_list
          call_api('get', ['event'])
        end

        private

        def call_api(method, resources = [])
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/')
          HTTP.headers('Accept' => 'application/json').send(method, url)
            .then { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = (200..299).freeze # rubocop:disable Style/RedundantFreeze

        def success?
          code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
        end

        def message
          payload['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end
