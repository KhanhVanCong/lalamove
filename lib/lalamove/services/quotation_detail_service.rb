# frozen_string_literal: true

module Lalamove
  module Services
    class QuotationDetailService < ActiveService::Base
      def initialize(quotation_id:)
        @quotation_id = quotation_id
      end

      def perform
        process
      end

      private

      attr_reader :quotation_id

      def process
        RequestService.perform!(action: :get, payload: nil, path: path)
      end

      def path
        "/v3/quotations/#{quotation_id}"
      end
    end
  end
end
