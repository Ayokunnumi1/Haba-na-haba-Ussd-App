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
  end
end
