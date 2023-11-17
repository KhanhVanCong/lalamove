# frozen_string_literal: true

module Lalamove
  module Resources
    class QuotationDetail < ActiveService::Base
      def initialize(quotation_id)
        @quotation_id = quotation_id
      end

      def perform
        process
      end

      private

      attr_reader :quotation_id

      def process
        Lalamove::Services::QuotationDetailService.perform!(quotation_id)
      end
    end
  end
end
