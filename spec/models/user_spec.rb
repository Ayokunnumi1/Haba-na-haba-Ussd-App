require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should belong_to(:branch).optional }
    it { should have_many(:request) }
    it { should have_many(:event_users) }
    it { should have_many(:events).through(:event_users) }
    it { should have_many(:notifications).dependent(:destroy) }
    it { should have_one_attached(:image) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:location) }
    it { should allow_value('1234567890').for(:phone_number) }
    it { should validate_inclusion_of(:role).in_array(User::ROLES).with_message(/is not a valid role/) }

    it 'Should allow user with valid attributes' do
      user = User.new(
        first_name: 'Chandan',
        last_name: 'Kumar',
        email: 'chandan@gmail.com',
        phone_number: '1234567890',
        password: '1234567',
        role: 'volunteer',
        gender: 'Male',
        location: 'City'
      )
      expect(user).to be_valid
    end

    it 'Should not allow user without first_name' do
      user = User.new(
        last_name: 'Kumar',
        email: 'chandan@gmail.com',
        phone_number: '1234567890',
        role: 'volunteer',
        password: '1234567',
        gender: 'Male',
        location: 'City'
      )
      expect(user).not_to be_valid
    end

    it 'Should not allow user without email' do
      user = User.new(
        first_name: 'Chandan',
        last_name: 'Kumar',
        phone_number: '1234567890',
        role: 'volunteer',
        password: '1234567',
        gender: 'Male',
        location: 'City'
      )
      expect(user).not_to be_valid
    end

    it 'Should not allow user without password' do
      user = User.new(
        first_name: 'Chandan',
        last_name: 'Kumar',
        email: 'chandan@gmail.com',
        phone_number: '1234567890',
        role: 'volunteer',
        gender: 'Male',
        location: 'City'
      )
      expect(user).not_to be_valid
    end

    it 'Should not allow user without role' do
      user = User.new(
        first_name: 'Chandan',
        last_name: 'Kumar',
        email: 'chandan@gmail.com',
        phone_number: '1234567890',
        password: '1234567',
        gender: 'Male',
        location: 'City'
      )
      expect(user).not_to be_valid
    end

    it 'Should not allow user without phone_number' do
      user = User.new(
        first_name: 'Chandan',
        last_name: 'Kumar',
        email: 'chandan@gmail.com',
        role: 'volunteer',
        password: '1234567',
        gender: 'Male',
        location: 'City'
      )
      expect(user).not_to be_valid
    end

    it 'Should not allow user without gender' do
      user = User.new(
        first_name: 'Chandan',
        last_name: 'Kumar',
        email: 'chandan@gmail.com',
        phone_number: '1234567890',
        role: 'volunteer',
        password: '1234567',
        location: 'City'
      )
      expect(user).not_to be_valid
    end
  end
end