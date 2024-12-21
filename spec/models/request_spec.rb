require 'rails_helper'

RSpec.describe Request, type: :model do
  describe 'Associations' do
    it 'belongs to district' do
      association = described_class.reflect_on_association(:district)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to county' do
      association = described_class.reflect_on_association(:county)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end

    it 'belongs to sub_county' do
      association = described_class.reflect_on_association(:sub_county)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end

    it 'belongs to branch' do
      association = described_class.reflect_on_association(:branch)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to event' do
      association = described_class.reflect_on_association(:event)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end

    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end

    it 'has one individual_beneficiary' do
      association = described_class.reflect_on_association(:individual_beneficiary)
      expect(association.macro).to eq :has_one
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'has one family_beneficiary' do
      association = described_class.reflect_on_association(:family_beneficiary)
      expect(association.macro).to eq :has_one
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'has one organization_beneficiary' do
      association = described_class.reflect_on_association(:organization_beneficiary)
      expect(association.macro).to eq :has_one
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'has many inventories' do
      association = described_class.reflect_on_association(:inventories)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :nullify
    end

    it 'has many notifications' do
      association = described_class.reflect_on_association(:notifications)
      expect(association.macro).to eq :has_many
      expect(association.options[:as]).to eq :notifiable
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'Validations' do
    it 'validates presence of name' do
      request = Request.new(name: nil)
      request.valid?
      expect(request.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of phone_number' do
      request = Request.new(phone_number: nil)
      request.valid?
      expect(request.errors[:phone_number]).to include("can't be blank")
    end

    it 'validates format of phone_number' do
      request = Request.new(phone_number: 'invalid_phone')
      request.valid?
      expect(request.errors[:phone_number]).to include('only allows numbers')
    end

    it 'validates presence of request_type' do
      request = Request.new(request_type: nil)
      request.valid?
      expect(request.errors[:request_type]).to include("can't be blank")
    end

    it 'validates presence of residence_address' do
      request = Request.new(residence_address: nil)
      request.valid?
      expect(request.errors[:residence_address]).to include("can't be blank")
    end
  end
end