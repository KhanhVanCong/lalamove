# frozen_string_literal: true

module Lalamove
  module Resources
    class CityInfo < ActiveService::Base
      def perform
        process
      end

      private
        def process
          Lalamove::Services::CityInfoService.perform!()
        end
    end
  end
end
