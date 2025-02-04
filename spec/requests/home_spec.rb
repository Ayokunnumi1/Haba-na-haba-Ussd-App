require 'rails_helper'

RSpec.describe 'Home', type: :request do
  before(:each) do
    @user = User.create!(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@example.com',
      password: 'Password123',
      phone_number: '0123456789',
      role: 'admin',
      gender: 'male',
      location: 'Some address'
    )

    @district = District.create!(name: 'District 1')
    @county = @district.counties.create!(name: 'County 1')
    @sub_county = @county.sub_counties.create!(name: 'SubCounty 1')
    @branch = Branch.create!(name: 'Main Branch', phone_number: '0123456789', district_ids: [@district.id])

    sign_in @user
  end

  describe 'GET /' do
    it 'should be response successful' do
      get root_path
      expect(response).to have_http_status(:ok)
    end

    it 'should render the index template' do
      get root_path
      expect(response).to render_template(:index)
    end

    it 'should include the placeholder for the request form' do
      get root_path
      expect(response.body).to include('Request')
    end
  end

  describe 'POST /create_request' do
    context 'with valid parameters' do
      it 'should create a new request and redirect to the root path with a notice' do
        post create_request_path, params: {
          request: {
            name: 'Request 1',
            phone_number: '0123456789',
            request_type: 'food_request',
            residence_address: '123 Street',
            district_id: @district.id,
            county_id: @county.id,
            sub_county_id: @sub_county.id,
            branch_id: @branch.id
          }
        }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('Request submitted successfully!')
      end
    end

    context 'with invalid parameters' do
      it 'should not create a request and render the index template with an alert' do
        post create_request_path, params: {
          request: {
            name: '',
            phone_number: ''
          }
        }

        expect(response).to have_http_status(204)
        expect(response.body).to include('')
      end
    end
  end
end
