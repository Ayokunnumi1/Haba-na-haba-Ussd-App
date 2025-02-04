require 'rails_helper'

RSpec.describe County, type: :model do
  describe 'Associations' do
    it 'belongs to district' do
      association = described_class.reflect_on_association(:district)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many sub_counties' do
      association = described_class.reflect_on_association(:sub_counties)
      expect(association.macro).to eq :has_many
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
      county = County.new(name: nil)
      county.valid?
      expect(county.errors[:name]).to include("can't be blank")
    end
  end

  describe 'Nested Attributes' do
    it 'allows nested attributes for sub_counties' do
      county = County.new(
        name: 'Test County',
        sub_counties_attributes: [
          { name: 'SubCounty 1' },
          { name: 'SubCounty 2' }
        ]
      )

      expect(county.sub_counties.size).to eq(2)
      expect(county.sub_counties.map(&:name)).to include('SubCounty 1', 'SubCounty 2')
    end

    it 'rejects nested attributes for sub_counties if all blank' do
      county = County.new(
        name: 'Test County',
        sub_counties_attributes: [
          { name: '' }
        ]
      )

      expect(county.sub_counties.size).to eq(0)
    end

    it 'destroys nested attributes for sub_counties' do
      # Create a district first
      district = District.create!(name: 'Test District')

      # Create a county with a valid district
      county = County.create!(
        name: 'Test County',
        district: district,
        sub_counties_attributes: [
          { name: 'SubCounty 1' },
          { name: 'SubCounty 2' }
        ]
      )

      # Validate initial state
      expect(county.persisted?).to be true
      expect(county.sub_counties.size).to eq(2)

      # Destroy one of the sub_counties
      sub_county = county.sub_counties.first
      county.update!(
        sub_counties_attributes: [
          { id: sub_county.id, _destroy: true }
        ]
      )

      # Reload the county and verify the result
      county.reload

      expect(county.sub_counties.size).to eq(1)
      expect(county.sub_counties.map(&:name)).not_to include('SubCounty 1')
    end
  end
end
