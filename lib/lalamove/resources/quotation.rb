# frozen_string_literal: true

module Lalamove
  module Resources
    class Quotation < ActiveService::Base
      def initialize(params)
        @params = params
        @stock_location = params[:stock_location]
        @orders = params[:orders].to_a
        @service_type = params[:service_type] || 'MOTORCYCLE'
        @schedule_at = params[:schedule_at]
      end

      def perform
        process
      end

      private

      attr_reader :params, :stock_location, :orders, :service_type, :schedule_at

      def process
        Lalamove::Services::QuotationService.perform!(payload)
      end

      def stop(location)
        {
          coordinates: { lat: location[:lat],
                         lng: location[:long] },
          address: location[:address]
        }
      end

      def delivery_stops
        stops = []
        stops << stop(stock_location)

        orders.each do |order|
          stops << stop(order)
        end

        stops
      end

      def payload
        {
          language: Lalamove.configuration.country,
          serviceType: service_type,
          stops: delivery_stops,
          specialRequests: [],
          scheduleAt: schedule_at.present? ? Time.zone.parse(schedule_at).utc.iso8601 : ''
        }
      end
    end
  end
end
