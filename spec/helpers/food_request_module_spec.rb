require 'rails_helper'

RSpec.describe FoodRequestModule, type: :helpers do
  let(:default_district) do
    District.create!(name: 'Default District')
  end
  let(:selected_district) do
    District.create!(name: 'Kampala')
  end
  let(:branch) do
    Branch.create!(name: 'Haba na Haba Branch', phone_number: '12345678', district_ids: [default_district.id])
  end
  let(:kampala_branch) do
    Branch.create!(name: 'Kampala Branch', phone_number: '123456732', district_ids: [selected_district.id])
  end
  let(:phone_number) { '256789123456' }



  describe '.process_request' do
    context 'when a valid district and branch are found' do
      it 'creates a new food request and sends an SMS' do
        kampala = District.create!(name: 'Kampala')
        kampala_branch = Branch.create!(name: 'Kampala', phone_number: '12345343', district_ids: [kampala.id])
        allow(SmsHelper).to receive(:send_sms)
        text = "1*RequestName*#{selected_district.name}"
        puts text
        result = FoodRequestModule.process_request(text, phone_number, nil)
        puts "#{result}. food module request result"

        request = Request.find_by(phone_number: phone_number)
        puts "#{request}. request by number"


        expect(request).not_to be_nil
        expect(request.name).to eq('RequestName')
        expect(request.district_id).to eq(kampala.id)
        expect(request.branch_id).to eq(kampala_branch.id)
        expect(result).to include("We are processing your request and will contact you shortly. Proceed to the branch #{kampala_branch.name} in #{selected_district.name} District.")
        expect(SmsHelper).to have_received(:send_sms).with(phone_number, /Proceed to the branch/)
      end
    end

    context 'when the district is not found' do
      it 'returns an error message' do
        text = '1*TestUser*Unknown District'
        result = FoodRequestModule.process_request(text, phone_number, nil)

        expect(result).to eq('END No matching district found.')
      end
    end

    context 'when the branch is not found' do
      it 'returns an error message' do
        District.create(name: 'NoBranchDistrict')

        text = '1*Request Name*NoBranchDistrict'
        result = FoodRequestModule.process_request(text, phone_number, nil)

        expect(result).to eq('END No branch found for the selected district.')
      end
    end

    context 'when the request cannot be saved' do
      it 'returns an error message' do
        allow(Request).to receive(:new).and_return(double(save: false))
        Branch.create!(name: 'Kampala Branch', phone_number: '12345678', district_ids: [default_district.id])
        text = '1*Test User*Kampala'
        result = FoodRequestModule.process_request(text, phone_number, nil)

        expect(result).to eq('END There was an issue processing your request. Please try again later.')
      end
    end
  end
end
