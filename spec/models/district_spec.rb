require 'rails_helper'

RSpec.describe District, type: :model do
  describe 'Associations' do
    it { should have_many(:counties).dependent(:destroy) }
    it { should accept_nested_attributes_for(:counties).allow_destroy(true) }
    it { should have_many(:branch_districts).dependent(:destroy) }
    it { should have_many(:branches).through(:branch_districts) }
    it { should have_many(:individual_beneficiaries).dependent(:nullify) }
    it { should have_many(:family_beneficiaries).dependent(:nullify) }
    it { should have_many(:organization_beneficiaries).dependent(:nullify) }
    it { should have_many(:inventories).dependent(:nullify) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'Nested Attributes' do
    it 'allows nested attributes for counties' do
      district = District.new(
        name: 'Test District',
        counties_attributes: [
          { name: 'County 1' },
          { name: 'County 2' }
        ]
      )

      expect(district.counties.size).to eq(2)
      expect(district.counties.map(&:name)).to include('County 1', 'County 2')
    end
  end

  describe 'Instance Methods' do
    it 'includes Matchable module' do
      expect(District.included_modules).to include(Matchable)
    end
  end
end
