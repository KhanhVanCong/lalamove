# frozen_string_literal: true

module Lalamove
  module Resources
    class CityInfo < ActiveService::Base
      def initialize()
        # @params = params
        # @stock_location = params[:stock_location]
        # @orders = params[:orders].to_a
        # @service_type = params[:service_type] || 'LALAGO'
      end

      def perform
        process
      end

      private

      # attr_reader :params, :stock_location, :orders, :service_type

      def process
        Lalamove::Services::CityInfoService.perform!()
      end

      # def payload
      #   {
      #     language: Lalamove.configuration.country,
      #     serviceType: service_type,
      #     stops: delivery_stops,
      #     specialRequests: []
      #   }
      # end
    end
  end
end
