require 'rails_helper'

RSpec.describe Branch, type: :model do
  describe 'Associations' do
    it 'has many branch_districts' do
      association = described_class.reflect_on_association(:branch_districts)
      expect(association.macro).to eq :has_many
    end

    it 'has many districts through branch_districts' do
      association = described_class.reflect_on_association(:districts)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :branch_districts
    end

    it 'has many users' do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'Validations' do
    it 'validates presence of name' do
      branch = Branch.new(name: nil)
      branch.valid?
      expect(branch.errors[:name]).to include('is required')
    end

    it 'validates presence of phone_number' do
      branch = Branch.new(phone_number: nil)
      branch.valid?
      expect(branch.errors[:phone_number]).to include('is required')
    end

    it 'validates format of phone_number' do
      branch = Branch.new(phone_number: 'invalid_phone')
      branch.valid?
      expect(branch.errors[:phone_number]).to include('must only contain numbers')
    end

    it 'validates custom validation must_have_at_least_one_district' do
      branch = Branch.new(name: 'Test Branch', phone_number: '1234567890')
      branch.valid?
      expect(branch.errors[:district_ids]).to include('must select at least one district')
    end
  end

  describe 'Custom Validations' do
    it 'adds an error if no districts are selected' do
      branch = Branch.new(name: 'Test Branch', phone_number: '1234567890')
      branch.valid?
      expect(branch.errors[:district_ids]).to include('must select at least one district')
    end

    it 'does not add an error if at least one district is selected' do
      district = District.create!(name: 'Test District')
      branch = Branch.new(name: 'Test Branch', phone_number: '1234567890', districts: [district])
      branch.valid?
      expect(branch.errors[:district_ids]).to be_empty
    end
  end
end