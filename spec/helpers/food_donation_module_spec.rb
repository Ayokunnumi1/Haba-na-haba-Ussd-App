require 'rails_helper'

RSpec.describe FoodDonationModule, type: :module do
  let(:phone_number) { '256700123456' }
  let(:session) {()}
  let(:valid_text) { '1*Food Donation*Kampala*Grains*Rice*50' }
  let(:district) do District.create(name: 'Kampala' ) end
  let(:district_test) do District.create(name: 'Wakiso' ) end
  let(:default_district) do District.create!(name: 'Default District') end
  let(:branch) do Branch.create(name: 'Kampala Branch', phone_number: '123454433', district_ids: [district.id]) end
  let(:default_branch) do Branch.create!(name: 'Haba na Haba Branch', phone_number: '1234567842', district_ids: [default_district.id]) end


  describe '.process_request' do
    context 'when all parameters are valid' do
      it 'creates a request and sends an SMS' do
        allow(SmsHelper).to receive(:send_sms)
        valid_text = '1*Food Donation*Kampala*Grains*Rice*50'
        puts "#{district} district"
        puts "#{branch} branch"
  
        response = described_class.process_request(valid_text, phone_number, session)

        request = Request.find_by(phone_number: phone_number)

        expect(request).not_to be_nil
        expect(request.name).to eq('Food Donation')
        expect(request.food_name).to eq('Rice')
        expect(request.food_type).to eq('Grains')
        expect(request.amount).to eq(50)
        expect(request.district).to eq(district)
        expect(request.branch).to eq(branch)
        expect(SmsHelper).to have_received(:send_sms).with(phone_number, /Thank you for your donation/)
        expect(response).to include('END Thank you for your donation')
      end
    end

    context 'when no matching district is found' do
      it 'returns an error message' do
        allow(District).to receive(:search_by_name).with('InvalidDistrict').and_return([])


        response = described_class.process_request('1*Food Donation*InvalidDistrict*Grains*Rice*50', phone_number, nil)
        expect(response).to eq('END No matching district found.')
      end
    end

    context 'when no matching branch is found' do
      it 'uses the default branch' do
        wakiso = District.create!(name: 'Wakiso')
        Branch.create!(name: 'Haba na Haba Branch', phone_number: '31232213', district_ids: [wakiso.id])


        allow(SmsHelper).to receive(:send_sms)
    
        invalid_text = '1*requestName*Wakiso*Grains*Rice*50'

        response = described_class.process_request(invalid_text, phone_number, nil)
        expect(response).to include('END Thank you for your donation we are reaching out to you shortly. Proceed to branch Haba na Haba Branch in Wakiso')
      end
    end

    context 'when the request fails validation' do
      it 'returns a failure message' do
        allow(District).to receive(:search_by_name).with('Kampala').and_return([district])
        allow(SmsHelper).to receive(:send_sms)
        kampala = District.create!(name: 'Kampala')
        Branch.create!(name: 'Haba na Haba Branch', phone_number: '31232213', district_ids: [kampala.id])

        requestValidation = allow_any_instance_of(Request).to receive(:save).and_return(false)

        response = described_class.process_request(valid_text, phone_number, nil)

        expect(response).to eq('END Your request was not processed. Please try again')
      end
    end
  end
end
