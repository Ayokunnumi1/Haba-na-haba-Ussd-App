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

    sign_in @user
    get '/users'
  end

  describe 'GET /index' do
    it 'should be response successful' do
      expect(response).to have_http_status(:ok)
    end

    it 'should render the user index file' do
      expect(response).to render_template(:index)
    end

    it 'should include the placeholder' do
      expect(response.body).to include('becky')
    end
  end

  describe 'GET /show' do
    it 'should be response successful' do
      get user_path(@user) 
      expect(response).to have_http_status(:ok)
    end

    it 'should render the show template' do
      get user_path(@user)
      expect(response).to render_template(:show)
    end

    it 'should include the user name' do
      get user_path(@user)
      expect(response.body).to include('becky')
    end
  end

  describe 'GET /new' do
    it 'should be response successfull' do
      get new_user_path
      expect(response).to have_http_status(:ok)
    end

    it 'should render the new file' do
      get new_user_path
      expect(response).to render_template(:new)
    end

    it 'should include the placeholder' do
      get new_user_path
      expect(response.body).to include('First name')
    end
  end

  describe 'POST /create' do
    it 'should create a new user' do
      post users_path,
           params: { user: { first_name: 'Bushra', last_name: 'khan', email: 'bushra@gmail.com', password: 'Abcdxyz123', password_confirmation: 'Abcdxyz123', phone_number: '01245145285', role: 'volunteer', gender: 'female', location: 'volunteer address'  } }
      expect(response).to have_http_status(:found)
      redirect_to(users_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('user was successfully created.')
    end

    it 'should render new template on invalid data' do
      post users_path,
           params: { user: { first_name: '', last_name: 'khan', email: '', password: '', password_confirmation: '', phone_number: '', role: 'volunteer', gender: 'female', location: 'volunteer address'  } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
      expect(flash.now[:alert]).to match(/Error: /)
    end
  end

  describe 'GET /edit' do
    it 'should be response successful' do
      get edit_user_path(@user)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the edit template' do
      get edit_user_path(@user)
      expect(response).to render_template(:edit)
    end

    it 'should include the form fields' do
      get edit_user_path(@user)
      expect(response.body).to include('Last name')
      expect(response.body).to include('First name')
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'should update the user and redirect to the user show page with a notice' do
        patch user_path(@user),
              params: { user: { first_name: 'Jane', last_name: 'Smith' } }
        @user.reload
        expect(@user.first_name).to eq('Jane')
        expect(@user.last_name).to eq('Smith')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(user_path(@user))
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('User was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'should not update the user and render the edit template with an alert' do
        patch user_path(@user),
              params: { user: { first_name: '', email: '' } }
        @user.reload
        expect(@user.first_name).not_to eq('')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to match(/Error: /)
      end
    end
  end
end
