require 'rails_helper'

RSpec.describe IndividualBeneficiary, type: :model do
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
    it 'validates presence of name' do
      individual_beneficiary = IndividualBeneficiary.new(name: nil)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of age' do
      individual_beneficiary = IndividualBeneficiary.new(age: nil)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:age]).to include("can't be blank")
    end

    it 'validates presence of gender' do
      individual_beneficiary = IndividualBeneficiary.new(gender: nil)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:gender]).to include("can't be blank")
    end

    it 'validates presence of residence_address' do
      individual_beneficiary = IndividualBeneficiary.new(residence_address: nil)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:residence_address]).to include("can't be blank")
    end

    it 'validates presence of village' do
      individual_beneficiary = IndividualBeneficiary.new(village: nil)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:village]).to include("can't be blank")
    end

    it 'validates presence of parish' do
      individual_beneficiary = IndividualBeneficiary.new(parish: nil)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:parish]).to include("can't be blank")
    end

    it 'validates presence of phone_number' do
      individual_beneficiary = IndividualBeneficiary.new(phone_number: nil)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:phone_number]).to include("can't be blank")
    end

    it 'validates format of phone_number' do
      individual_beneficiary = IndividualBeneficiary.new(phone_number: 'invalid_phone')
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:phone_number]).to include('only allows numbers')
    end

    it 'validates presence of case_name' do
      individual_beneficiary = IndividualBeneficiary.new(case_name: nil)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:case_name]).to include("can't be blank")
    end

    it 'validates presence of case_description' do
      individual_beneficiary = IndividualBeneficiary.new(case_description: nil)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:case_description]).to include("can't be blank")
    end

    it 'validates presence of fathers_name' do
      individual_beneficiary = IndividualBeneficiary.new(fathers_name: nil)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:fathers_name]).to include("can't be blank")
    end

    it 'validates presence of mothers_name' do
      individual_beneficiary = IndividualBeneficiary.new(mothers_name: nil)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:mothers_name]).to include("can't be blank")
    end

    it 'validates numericality of provided_food' do
      individual_beneficiary = IndividualBeneficiary.new(provided_food: -1)
      individual_beneficiary.valid?
      expect(individual_beneficiary.errors[:provided_food]).to include('must be greater than or equal to 0')
    end
  end
end
