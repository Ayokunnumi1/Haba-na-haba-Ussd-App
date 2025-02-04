require 'rails_helper'

RSpec.describe FamilyBeneficiary, type: :model do
  describe 'Associations' do
    it 'belongs to district' do
      association = described_class.reflect_on_association(:district)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to county' do
      association = described_class.reflect_on_association(:county)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to sub_county' do
      association = described_class.reflect_on_association(:sub_county)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to request' do
      association = described_class.reflect_on_association(:request)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end

    it 'belongs to branch' do
      association = described_class.reflect_on_association(:branch)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end

    it 'belongs to event' do
      association = described_class.reflect_on_association(:event)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end
  end

  describe 'Validations' do
    it 'validates presence of family_members' do
      family_beneficiary = FamilyBeneficiary.new(family_members: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:family_members]).to include("can't be blank")
    end

    it 'validates presence of male' do
      family_beneficiary = FamilyBeneficiary.new(male: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:male]).to include("can't be blank")
    end

    it 'validates presence of female' do
      family_beneficiary = FamilyBeneficiary.new(female: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:female]).to include("can't be blank")
    end

    it 'validates presence of children' do
      family_beneficiary = FamilyBeneficiary.new(children: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:children]).to include("can't be blank")
    end

    it 'validates presence of residence_address' do
      family_beneficiary = FamilyBeneficiary.new(residence_address: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:residence_address]).to include("can't be blank")
    end

    it 'validates presence of village' do
      family_beneficiary = FamilyBeneficiary.new(village: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:village]).to include("can't be blank")
    end

    it 'validates presence of parish' do
      family_beneficiary = FamilyBeneficiary.new(parish: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:parish]).to include("can't be blank")
    end

    it 'validates presence of phone_number' do
      family_beneficiary = FamilyBeneficiary.new(phone_number: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:phone_number]).to include("can't be blank")
    end

    it 'validates format of phone_number' do
      family_beneficiary = FamilyBeneficiary.new(phone_number: 'invalid_phone')
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:phone_number]).to include('only allows numbers')
    end

    it 'validates presence of case_name' do
      family_beneficiary = FamilyBeneficiary.new(case_name: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:case_name]).to include("can't be blank")
    end

    it 'validates presence of case_description' do
      family_beneficiary = FamilyBeneficiary.new(case_description: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:case_description]).to include("can't be blank")
    end

    it 'validates presence of fathers_name' do
      family_beneficiary = FamilyBeneficiary.new(fathers_name: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:fathers_name]).to include("can't be blank")
    end

    it 'validates presence of mothers_name' do
      family_beneficiary = FamilyBeneficiary.new(mothers_name: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:mothers_name]).to include("can't be blank")
    end

    it 'validates presence of fathers_occupation' do
      family_beneficiary = FamilyBeneficiary.new(fathers_occupation: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:fathers_occupation]).to include("can't be blank")
    end

    it 'validates presence of mothers_occupation' do
      family_beneficiary = FamilyBeneficiary.new(mothers_occupation: nil)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:mothers_occupation]).to include("can't be blank")
    end

    it 'validates numericality of provided_food' do
      family_beneficiary = FamilyBeneficiary.new(provided_food: -1)
      family_beneficiary.valid?
      expect(family_beneficiary.errors[:provided_food]).to include('must be greater than or equal to 0')
    end
  end
end
