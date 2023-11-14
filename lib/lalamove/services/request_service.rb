# frozen_string_literal: true

module Lalamove
  module Services
    class RequestService < ActiveService::Base
      def initialize(params = {})
        @params  = params
        @payload = { data: params[:payload] }&.to_json if params[:payload]
      end

      def perform
        result = connection.send(params[:action], params[:path], payload)

        return failure(result) unless result.success?

        response(data: parser(result.body), status: result.status)
      end

      private

      attr_reader :params, :payload

      def connection
        @connection ||= Faraday.new(
          url: Lalamove.configuration.host,
          headers: headers,
          request: {
            open_timeout: 10,
            timeout: 20
          }
        )
      end

      def timestamp
        @timestamp ||= (Time.now.utc.to_f * 1000).to_i
      end

      def signature
        OpenSSL::HMAC.hexdigest(
          'sha256',
          Lalamove.configuration.secret,
          "#{timestamp}\r\n#{params[:action].to_s.upcase}\r\n#{params[:path]}\r\n\r\n#{payload}"
        )
      end

      def headers
        {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "hmac #{Lalamove.configuration.token}:#{timestamp}:#{signature}",
          'X-Request-ID': timestamp.to_s,
          'MARKET': Lalamove.configuration.market
        }
      end

      def parser(attr)
        return {} if attr&.empty?

        JSON.parse(attr, symbolize_names: true)
      end

      def failure(result)
        result_body = parser(result.body)[:errors].first
        message = result_body[:detail].blank? ? result_body[:message] : "#{result_body[:detail]} - #{result_body[:message]}"
        response(
          errors: result_body[:id],
          status: result.status,
          message: message
        )
      end
    end
  end
end
