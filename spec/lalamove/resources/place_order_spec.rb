# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lalamove::Resources::PlaceOrder do
  let(:address_1) { { lat: '1.28041', long: '103.841', address: '1 Teo Hong Rd, Singapore 088321' } }
  let(:address_2) { { lat: '1.2842', long: '103.842', address: "195 Pearl's Hill Terrace, 195 Pearl's Hill Terrace, Singapore 168976" } }
  let(:destination_locations) { [address_1] }

  let(:recipient_1) { { name: 'Lala', phone: '+6599999999', remarks: 'noted' } }
  let(:recipient_2) { { name: 'Lala 2', phone: '+6588223322', remarks: 'noted 2' } }
  let(:recipients) { [recipient_1] }

  describe '#perform' do
    subject do
      described_class.perform!(quotation_id: @quotation_id,
                               sender: { name: 'Joe',
                                         phone: '+6588112233' },
                               recipients: recipients,
                               metadata: nil)
    end

    context 'when success' do
      before(:each) do
        stock_location = { lat: '1.35868',
                           long: '103.834',
                           address: '18 Sin Ming Lane' }
        quotation = Lalamove::Client.quotation.perform!(stock_location: stock_location,
                                                        orders: destination_locations,
                                                        schedule_at: Date.today.next_day.strftime('%Y-%m-%d %H:%M SGT'))
        @quotation_id = quotation.data.dig(:data, :quotationId)
      end
      it 'returns a valid response' do
        is_expected.to be_valid
      end

      context 'when payload has more than one order' do
        let(:destination_locations) { [address_1, address_2] }
        let(:recipients) { [recipient_1, recipient_2] }

        it 'returns a valid response' do
          is_expected.to be_valid
        end
      end
    end

    context 'when failure' do
      @quotation_id = 'invalid_id'

      it 'returns a invalid response with request errors' do
        expect(Lalamove::Services::OrderCreatorService).not_to receive(:perform!)
      end
    end
  end
end
