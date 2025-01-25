require 'rails_helper'

RSpec.describe "Users", type: :request do

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

    sign_in @user
    get '/districts'
  end

  describe 'GET /index' do
    it 'should be response successful' do
      expect(response).to have_http_status(:ok)
    end

    it 'should render the user index file' do
      expect(response).to render_template(:index)
    end

    it 'should include the placeholder' do
      expect(response.body).to include('District 1')
    end
  end

  describe 'GET /show' do
    it 'should be response successful' do
      get district_path(@district) 
      expect(response).to have_http_status(:ok)
    end

    it 'should render the show template' do
      get district_path(@district)
      expect(response).to render_template(:show)
    end

    it 'should include the district name' do
      get district_path(@district)
      expect(response.body).to include('District 1')
    end
  end

  describe 'GET /new' do
    it 'should be response successfull' do
      get new_district_path
      expect(response).to have_http_status(:ok)
    end

    it 'should render the new file' do
      get new_district_path
      expect(response).to render_template(:new)
    end

    it 'should include the placeholder' do
      get new_district_path
      expect(response.body).to include('District')
    end
  end

  describe 'POST /create' do
    it 'should create a new district' do
      post districts_path,
           params: { district: { name: "District 2" } }
      expect(response).to have_http_status(:found)
      redirect_to(districts_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('District, Counties, and SubCounties were successfully created.')
    end

    it 'should render new template on invalid data' do
      post districts_path,
           params: { district: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
      expect(flash.now[:alert]).to match(/Error: /)
    end
  end

  describe 'GET /edit' do
    it 'should be response successful' do
      get edit_district_path(@district)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the edit template' do
      get edit_district_path(@district)
      expect(response).to render_template(:edit)
    end

    it 'should include the form fields' do
      get edit_district_path(@district)
      expect(response.body).to include('District')
      expect(response.body).to include('County')
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'should update the district and redirect to the district show page with a notice' do
        patch district_path(@district),
              params: { district: { name: 'District 4' } }
        @district.reload
        expect(@district.name).to eq('District 4')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(district_path(@district))
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('District, Counties, and SubCounties were successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'should not update the district and render the edit template with an alert' do
        patch district_path(@district),
              params: { district: { name: '' } }
        @district.reload
        expect(@district.name).not_to eq('')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to match(/Error: /)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when deletion is successful' do
      it 'deletes the district and redirects to the index page with a success notice' do
        expect {
          delete district_path(@district)
        }.to change(District, :count).by(-1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(districts_path)
        follow_redirect!
        expect(response.body).to include('District was successfully deleted.')
      end
    end

    context 'when deletion is unsuccessful' do
      before do
        allow_any_instance_of(District).to receive(:destroy).and_return(false)
        allow_any_instance_of(District).to receive_message_chain(:errors, :full_messages).and_return(['Deletion failed due to dependencies.'])
      end

      it 'does not delete the district and redirects to the index page with an error alert' do
        expect {
          delete district_path(@district)
        }.not_to change(District, :count)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(districts_path)
        follow_redirect!
        expect(response.body).to include('Deletion failed due to dependencies.')
      end
    end
  end
end
