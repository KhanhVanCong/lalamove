# frozen_string_literal: true

module Lalamove
  module Resources
    class PlaceOrder < ActiveService::Base
      def initialize(params)
        @params = params
        @quotation_id = params[:quotation_id]
        @sender = params[:sender]
        @recipients = params[:recipients]
        @metadata = params[:metadata]
      end

      def perform
        process
      end

      private

        attr_reader :params, :quotation_id, :sender, :recipients, :metadata
        def quotation
          @quotation ||= Lalamove::Client.quotation_detail.perform!(quotation_id: quotation_id)
        end

        def creation
          Lalamove::Services::OrderCreatorService.perform!(payload_with_detail_contact)
        end

        def process
          unless quotation.valid?
            raise CustomException.new(ErrorCodes::ERROR_LIST[:LALAMOVE_QUOTATION_INVALID],
                                      ErrorDescriptions::ERROR_LIST[:LALAMOVE_QUOTATION_INVALID]),
                  ErrorDescriptions::ERROR_LIST[:LALAMOVE_QUOTATION_INVALID]
          end

          creation
        end

        def delivery_stops_id
          quotation.data.dig(:data, :stops).map { |x| x[:stopId] }
        end

        def payload_with_detail_contact
          {
            quotationId: quotation.data.dig(:data, :quotationId),
            sender: {
              stopId: delivery_stops_id.first,
              name: sender[:name],
              phone: sender[:phone]
            },
            recipients: deliveries,
            isPODEnabled: true,
            isRecipientSMSEnabled: false,
            metadata: metadata
          }
        end

        def deliveries
          recipients.each_with_index.map do |recipient, pos|
            {
              stopId: delivery_stops_id[pos + 1],
              name: recipient[:name],
              phone: recipient[:phone],
              remarks: "Booking Ref: #{recipient[:booking_id]}\r\nSender's Address Unit No: #{recipient[:sender_address_unit_no]}\r\nRecipient's Address Unit No: #{recipient[:recipient_address_unit_no]}"
            }
          end
        end
    end
  end
end
