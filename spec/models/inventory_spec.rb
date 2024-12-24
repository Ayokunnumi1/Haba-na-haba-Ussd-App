require 'rails_helper'

RSpec.describe Inventory, type: :model do
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
    it 'validates format of phone_number' do
      inventory = Inventory.new(phone_number: 'invalid_phone')
      inventory.valid?
      expect(inventory.errors[:phone_number]).to include('only allows numbers')
    end

    it 'validates numericality of collection_amount' do
      inventory = Inventory.new(collection_amount: -1)
      inventory.valid?
      expect(inventory.errors[:collection_amount]).to include('must be greater than or equal to 0')
    end
  end
end
