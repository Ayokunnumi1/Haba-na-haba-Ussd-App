require 'rails_helper'

RSpec.describe OrganizationBeneficiary, type: :model do
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
    it 'validates presence of organization_name' do
      organization_beneficiary = OrganizationBeneficiary.new(organization_name: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:organization_name]).to include("can't be blank")
    end

    it 'validates presence of male' do
      organization_beneficiary = OrganizationBeneficiary.new(male: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:male]).to include("can't be blank")
    end

    it 'validates presence of female' do
      organization_beneficiary = OrganizationBeneficiary.new(female: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:female]).to include("can't be blank")
    end

    it 'validates presence of residence_address' do
      organization_beneficiary = OrganizationBeneficiary.new(residence_address: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:residence_address]).to include("can't be blank")
    end

    it 'validates presence of village' do
      organization_beneficiary = OrganizationBeneficiary.new(village: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:village]).to include("can't be blank")
    end

    it 'validates presence of parish' do
      organization_beneficiary = OrganizationBeneficiary.new(parish: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:parish]).to include("can't be blank")
    end

    it 'validates presence of phone_number' do
      organization_beneficiary = OrganizationBeneficiary.new(phone_number: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:phone_number]).to include("can't be blank")
    end

    it 'validates format of phone_number' do
      organization_beneficiary = OrganizationBeneficiary.new(phone_number: 'invalid_phone')
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:phone_number]).to include('only allows numbers')
    end

    it 'validates presence of case_name' do
      organization_beneficiary = OrganizationBeneficiary.new(case_name: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:case_name]).to include("can't be blank")
    end

    it 'validates presence of case_description' do
      organization_beneficiary = OrganizationBeneficiary.new(case_description: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:case_description]).to include("can't be blank")
    end

    it 'validates presence of registration_no' do
      organization_beneficiary = OrganizationBeneficiary.new(registration_no: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:registration_no]).to include("can't be blank")
    end

    it 'validates presence of organization_no' do
      organization_beneficiary = OrganizationBeneficiary.new(organization_no: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:organization_no]).to include("can't be blank")
    end

    it 'validates presence of directors_name' do
      organization_beneficiary = OrganizationBeneficiary.new(directors_name: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:directors_name]).to include("can't be blank")
    end

    it 'validates presence of head_of_institution' do
      organization_beneficiary = OrganizationBeneficiary.new(head_of_institution: nil)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:head_of_institution]).to include("can't be blank")
    end

    it 'validates numericality of provided_food' do
      organization_beneficiary = OrganizationBeneficiary.new(provided_food: -1)
      organization_beneficiary.valid?
      expect(organization_beneficiary.errors[:provided_food]).to include('must be greater than or equal to 0')
    end
  end
end
