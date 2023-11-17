# frozen_string_literal: true

module Lalamove
  module Services
    class CityInfoService < ActiveService::Base
      def initialize(params = {})
        @params = params
      end

      def perform
        process
      end

      private

      attr_reader :params

      def process
        RequestService.perform!(action: :get, payload: nil, path: '/v3/cities')
      end
    end
  end
end
