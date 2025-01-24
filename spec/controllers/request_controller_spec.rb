require 'rails_helper'

def create_user(role, gender, first_name, last_name, branch_id = nil)
  User.create! do |user|
    user.email = "#{role}@example.com"
    user.password = 'password123'
    user.first_name = first_name
    user.last_name = last_name
    user.role = role
    user.branch_id = branch_id
    user.gender = gender
    user.location = 'Kampala'
    user.phone_number = '12345678'
  end
end

def create_request(overrides = {})
  Request.create! do |request|
    request.name = overrides[:name] || 'Test Request'
    request.phone_number = overrides[:phone_number] || '1234567890'
    request.request_type = overrides[:request_type] || 'Type A'
    request.residence_address = overrides[:residence_address] || '123 Test St.'
    request.district_id = overrides[:district_id] || District.first.id
    request.county_id = overrides[:county_id] || County.first.id
    request.sub_county_id = overrides[:sub_county_id] || SubCounty.first.id
    request.branch_id = overrides[:branch_id] || Branch.first.id
    request.user_id = overrides[:user_id] || User.first.id
  end
end

RSpec.describe RequestsController, type: :controller do
  let(:branch) { Branch.create!(name: 'Test Branch', phone_number: '123456787', district_ids: [district.id]) }
  let(:manager) { create_user('branch_manager', 'male', 'Test', 'User', branch.id) }
  let(:volunteer) { create_user('volunteer', 'female', 'Test', 'User', branch.id) }
  let(:district) { District.create!(name: 'Test District') }
  let(:county) { County.create!(name: 'Test County', district_id: district.id) }
  let(:sub_county) { SubCounty.create!(name: 'Test SubCounty', county_id: county.id) }

  before do
    sign_in(manager)
    district
    county
    sub_county
    branch
  end

  describe 'GET #index' do
    it 'assigns @requests based on the branch manager role' do
      create_request(branch_id: branch.id)
      get :index
      expect(assigns(:requests).count).to eq(1)
    end

    it 'filters requests for volunteers' do
      sign_in(volunteer)
      create_request(user_id: volunteer.id)
      get :index
      expect(assigns(:requests).count).to eq(1)
    end
  end

  describe 'POST #create' do
    it 'creates a new request and notifies branch managers' do
      expect do
        post :create, params: {
          request: {
            name: 'New Request',
            phone_number: '1234567890',
            request_type: 'Type A',
            residence_address: '123 Test St.',
            district_id: district.id,
            county_id: county.id,
            sub_county_id: sub_county.id,
            branch_id: branch.id,
            user_id: manager.id
          }
        }
      end.to change(Request, :count).by(1)
      expect(flash[:notice]).to eq('Request was successfully created.')
    end
  end

  describe 'PUT #update' do
    it 'updates an existing request and notifies the user' do
      request = create_request(branch_id: branch.id)
      put :update, params: { id: request.id, request: { name: 'Updated Name' } }
      expect(request.reload.name).to eq('Updated Name')
      expect(flash[:notice]).to eq('Request was successfully updated.')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a request' do
      request = create_request(branch_id: branch.id)
      expect do
        delete :destroy, params: { id: request.id }
      end.to change(Request, :count).by(-1)
      expect(flash[:notice]).to eq('Request was successfully destroyed.')
    end
  end
end
