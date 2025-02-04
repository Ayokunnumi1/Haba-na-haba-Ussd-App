require 'rails_helper'

RSpec.describe 'Requests', type: :request do
  before(:each) do
    @user = User.create!(
      first_name: 'becky',
      last_name: 'khan',
      email: 'becky@mail.com',
      password: 'ABabcxyz123',
      phone_number: '012457896365',
      role: 'admin',
      gender: 'female',
      location: 'admin address'
    )

    @user.image.attach(
      io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'image.jpg')),
      filename: 'image.jpg',
      content_type: 'image/jpg'
    )

    @district = District.create!(name: 'District 1')
    @district2 = District.create!(name: 'District 2')
    @county = County.create!(name: 'County 1', district_id: @district.id)
    @county2 = County.create!(name: 'County 2', district_id: @district2.id)
    @sub_county = SubCounty.create!(name: 'Sub County 1', county_id: @county.id)
    @branch = Branch.create!(name: 'Kampala Branch', phone_number: '0123456789', district_ids: [@district.id])
    @request1 = Request.create!(name: 'Request 1', phone_number: '010101010101', request_type: 'food_request',
                                residence_address: 'abc', is_selected: nil, district_id: @district.id,
                                branch_id: @branch.id, user_id: @user.id)

    sign_in @user
    get '/requests'
  end


  describe 'GET /index' do
    it 'should be response successful' do
      expect(response).to have_http_status(:ok)
    end

    it 'should render the user index file' do
      expect(response).to render_template(:index)
    end

    it 'should include the placeholder' do
      expect(response.body).to include('Request 1')
    end
  end

  describe 'USSD /ussd_request' do
    it 'should send a plain response' do
      expect(response.content_type).to eq('text/html; charset=utf-8')
    end

    it 'calls the process_ussd method' do
      allow(EnglishMenu).to receive(:process_menu).and_return('Welcome to Haba na Haba')
      post ussd_request_path, params: { phone_number: '123456789', text: '1' }
      expect(response.body).to eq('Welcome to Haba na Haba')
    end
  end

  describe 'GET /show' do
    it 'should be response successful' do
      get request_path(Request.first)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the show template' do
      get request_path(Request.first)
      expect(response).to render_template(:show)
    end

    it 'should include the request name' do
      get request_path(Request.first)
      expect(response.body).to include(Request.first.name)
    end
  end

  describe 'GET /new' do
    it 'should be response successfull' do
      get new_request_path
      expect(response).to have_http_status(:ok)
    end

    it 'should render the new file' do
      get new_request_path
      expect(response).to render_template(:new)
    end

    it 'should include the placeholder' do
      get new_request_path
      expect(response.body).to include('Branch')
    end
  end

  describe 'POST /create' do
    it 'should create a new request' do
      post requests_path,
           params: { request: { name: 'Request 2', phone_number: '010101010101', request_type: 'food_request',
                                residence_address: 'abc', is_selected: nil, district_id: @district.id,
                                branch_id: @branch.id, user_id: @user.id } }
      expect(response).to have_http_status(:found)
      redirect_to(requests_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Request was successfully created.')
    end

    it 'should render new template on invalid data' do
      post requests_path,
           params: { request: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
      expect(flash.now[:alert]).to match(/Error: /)
    end
  end

  describe 'GET /edit' do
    it 'should be response successful' do
      get edit_request_path(Request.first)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the edit template' do
      get edit_request_path(Request.first)
      expect(response).to render_template(:edit)
    end

    it 'should include the form fields' do
      get edit_request_path(Request.first)
      expect(response.body).to include('Request')
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'should update the request and redirect to the request show page with a notice' do
        patch request_path(@request1),
              params: { request: { name: 'request 4' } }
        @request1.reload
        expect(@request1.name).to eq('request 4')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(request_path(@request1))
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Request was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'should not update the request and render the edit template with an alert' do
        patch request_path(@request1),
              params: { request: { name: '' } }
        @request1.reload
        expect(@request1.name).not_to eq('')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to match(/Error: /)
      end
    end
  end


  describe 'GET /load_counties' do
    it 'returns counties when district_id is provided' do
      get load_counties_requests_path, params: { district_id: @district.id }
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.first['name']).to eq('County 1')
    end

    it 'returns an empty array when no district_id is provided' do
      get load_counties_requests_path
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response).to eq([])
    end
  end

  describe 'GET /load_sub_counties' do
    it 'returns sub_counties when county_id is provided' do
      get load_sub_counties_requests_path, params: { county_id: @county.id }
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.first['name']).to eq('Sub County 1')
    end

    it 'returns an empty array when no county_id is provided' do
      get load_sub_counties_requests_path
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response).to eq([])
    end
  end


  describe 'DELETE /destroy' do
    context 'when deletion is successful' do
      it 'deletes the request and redirects to the index page with a success notice' do
        expect do
          delete request_path(@request1)
        end.to change(Request, :count).by(-1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(requests_path)
        follow_redirect!
        expect(response.body).to include('Request was successfully destroyed.')
      end
    end

    context 'when deletion is unsuccessful' do
      before do
        allow_any_instance_of(Request).to receive(:destroy).and_return(false)
        allow_any_instance_of(Request).to receive_message_chain(:errors, :full_messages).and_return(['Deletion failed due to dependencies.'])
      end

      it 'does not delete the request and redirects to the index page with an error alert' do
        expect do
          delete request_path(@request1)
        end.not_to change(Request, :count)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(requests_path)
        follow_redirect!
      end
    end
  end
end
