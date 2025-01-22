require 'rails_helper'

RSpec.describe OtherDonationModule, type: :helpers do
  let(:phone_number) { '256700123456' }
  let(:valid_text) { '1*Donation*Kampala*1*1000' }
  let(:invalid_donation_type_text) { '1*Donation*Kampala*5*1000' }
  let(:no_district_text) { '1*Donation*InvalidDistrict*1*1000' }
  let(:default_district) { District.create!(name: 'Default District') }
  let(:district) { District.create!(name: 'Kampala') }
  let(:branch) { Branch.create!(name: 'Kampala Branch', phone_number: '123454433', district_ids: [district.id]) }
  let(:default_branch) { Branch.create!(name: 'Haba na Haba Branch', phone_number: '1234567842', district_ids: [default_district.id]) }

  before do
    allow(SmsHelper).to receive(:send_sms)
  end

  describe '.process_menu_request' do
    context 'when all parameters are valid' do
      it 'creates a request and sends an SMS' do
        district
        branch

        response = described_class.process_menu_request(valid_text, phone_number, nil)

        request = Request.find_by(phone_number:)
        expect(request).not_to be_nil
        expect(request.name).to eq('Donation')
        expect(request.request_type).to eq('cash_donation')
        expect(request.amount).to eq(1000)
        expect(request.district).to eq(district)
        expect(request.branch).to eq(branch)
        expect(SmsHelper).to have_received(:send_sms).with(phone_number, include('Thank you for your Cash donation'))
        expect(response).to eq('END Thank you for your donation. We are processing your request and will call you shortly.')
      end
    end

    context 'when the donation type is invalid' do
      it 'returns an error message' do
        response = described_class.process_menu_request(invalid_donation_type_text, phone_number, nil)

        expect(response).to eq('END Invalid donation type selected.')
      end
    end

    context 'when no matching district is found' do
      it 'uses the default district and branch' do
        default_district
        default_branch

        response = described_class.process_menu_request(no_district_text, phone_number, nil)

        request = Request.find_by(phone_number:)
        expect(request).not_to be_nil
        expect(request.district).to eq(default_district)
        expect(request.branch).to eq(default_branch)

        expect(response).to include('END Thank you for your donation. We are processing your request and will call you shortly.')
      end
    end

    context 'when no matching branch is found' do
      it 'returns an error message' do
        district

        response = described_class.process_menu_request(valid_text, phone_number, nil)

        expect(response).to eq('END No branch found for the selected district and county.')
      end
    end
  end
end
