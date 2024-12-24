require 'rails_helper'

RSpec.describe Event, type: :model do
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

    it 'has many requests' do
      association = described_class.reflect_on_association(:requests)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'has many event_users' do
      association = described_class.reflect_on_association(:event_users)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'has many users through event_users' do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :event_users
    end

    it 'has many individual_beneficiaries' do
      association = described_class.reflect_on_association(:individual_beneficiaries)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'has many family_beneficiaries' do
      association = described_class.reflect_on_association(:family_beneficiaries)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'has many organization_beneficiaries' do
      association = described_class.reflect_on_association(:organization_beneficiaries)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'has many inventories' do
      association = described_class.reflect_on_association(:inventories)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'Validations' do
    it 'validates presence of name' do
      event = Event.new(name: nil)
      event.valid?
      expect(event.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of start_date' do
      event = Event.new(start_date: nil)
      event.valid?
      expect(event.errors[:start_date]).to include("can't be blank")
    end

    it 'validates presence of end_date' do
      event = Event.new(end_date: nil)
      event.valid?
      expect(event.errors[:end_date]).to include("can't be blank")
    end

    it 'validates presence of start_time' do
      event = Event.new(start_time: nil)
      event.valid?
      expect(event.errors[:start_time]).to include("can't be blank")
    end

    it 'validates presence of end_time' do
      event = Event.new(end_time: nil)
      event.valid?
      expect(event.errors[:end_time]).to include("can't be blank")
    end

    it 'validates end_date is after start_date' do
      event = Event.new(start_date: Date.today, end_date: Date.yesterday)
      event.valid?
      expect(event.errors[:end_date]).to include('must be after or on the same day as the start date')
    end

    it 'validates end_time is after start_time if on the same day' do
      event = Event.new(start_date: Date.today, end_date: Date.today, start_time: '12:00', end_time: '11:00')
      event.valid?
      expect(event.errors[:end_time]).to include('must be after the start time if the event is on the same day')
    end
  end

  describe 'Custom Validations' do
    it 'adds an error if end_date is before start_date' do
      event = Event.new(start_date: Date.today, end_date: Date.yesterday)
      event.valid?
      expect(event.errors[:end_date]).to include('must be after or on the same day as the start date')
    end

    it 'adds an error if end_time is before start_time on the same day' do
      event = Event.new(start_date: Date.today, end_date: Date.today, start_time: '12:00', end_time: '11:00')
      event.valid?
      expect(event.errors[:end_time]).to include('must be after the start time if the event is on the same day')
    end

    it 'does not add an error if end_date is after start_date' do
      event = Event.new(start_date: Date.today, end_date: Date.tomorrow)
      event.valid?
      expect(event.errors[:end_date]).to be_empty
    end

    it 'does not add an error if end_time is after start_time on the same day' do
      event = Event.new(start_date: Date.today, end_date: Date.today, start_time: '12:00', end_time: '13:00')
      event.valid?
      expect(event.errors[:end_time]).to be_empty
    end
  end
end
