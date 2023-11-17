# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lalamove::Resources::Quotation do
  let(:address_1) { { lat: '1.28041', long: '103.841', address: '1 Teo Hong Rd, Singapore 088321' } }
  let(:destination_locations) { [address_1] }
  let(:stock_location) { { lat: '1.35868', long: '103.834', address: '18 Sin Ming Lane' } }

  describe '#perform', :vcr do
    subject do
      described_class.perform!(stock_location: stock_location,
                               orders: destination_locations,
                               schedule_at: Date.today.next_day.strftime('%Y-%m-%d %H:%M SGT'))
    end

    context 'when success' do
      it 'returns a valid response' do
        expect(Lalamove::Services::QuotationService).to receive(:perform!).once.and_call_original

        is_expected.to be_valid
      end
    end

    context 'when success with car' do
      let(:payload) { params_from_json('order_for_car') }
      it 'returns a valid response' do
        expect(Lalamove::Services::QuotationService).to receive(:perform!).once.and_call_original

        is_expected.to be_valid
      end
    end

    context 'when failure' do
      let(:payload) { params_from_json('invalid_order') }

      it 'returns a invalid response with request errors' do
        is_expected.not_to be_valid
      end
    end
  end
end
