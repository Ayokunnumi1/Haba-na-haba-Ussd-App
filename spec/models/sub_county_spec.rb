require 'rails_helper'

RSpec.describe SubCounty, type: :model do
  describe 'Associations' do
    it 'belongs to county' do
      association = described_class.reflect_on_association(:county)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many individual_beneficiaries' do
      association = described_class.reflect_on_association(:individual_beneficiaries)
      expect(association.macro).to eq :has_many
    end

    it 'has many family_beneficiaries' do
      association = described_class.reflect_on_association(:family_beneficiaries)
      expect(association.macro).to eq :has_many
    end

    it 'has many organization_beneficiaries' do
      association = described_class.reflect_on_association(:organization_beneficiaries)
      expect(association.macro).to eq :has_many
    end

    it 'has many inventories' do
      association = described_class.reflect_on_association(:inventories)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'Validations' do
    it 'validates presence of name' do
      sub_county = SubCounty.new(name: nil)
      sub_county.valid?
      expect(sub_county.errors[:name]).to include("can't be blank")
    end
  end
end