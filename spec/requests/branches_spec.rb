require 'rails_helper'

RSpec.describe 'Branches', type: :request do
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
    @branch = Branch.create!(name: 'Kampala Branch', phone_number: '0123456789', district_ids: [@district.id])

    sign_in @user
    get '/branches'
  end

  describe 'GET /index' do
    it 'should be response successful' do
      expect(response).to have_http_status(:ok)
    end

    it 'should render the user index file' do
      expect(response).to render_template(:index)
    end

    it 'should include the placeholder' do
      expect(response.body).to include('Kampala Branch')
    end
  end

  describe 'GET /show' do
    it 'should be response successful' do
      get branch_path(@branch)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the show template' do
      get branch_path(@branch)
      expect(response).to render_template(:show)
    end

    it 'should include the branch name' do
      get branch_path(@branch)
      expect(response.body).to include('Kampala Branch')
    end
  end

  describe 'GET /new' do
    it 'should be response successfull' do
      get new_branch_path
      expect(response).to have_http_status(:ok)
    end

    it 'should render the new file' do
      get new_branch_path
      expect(response).to render_template(:new)
    end

    it 'should include the placeholder' do
      get new_branch_path
      expect(response.body).to include('Branch')
    end
  end

  describe 'POST /create' do
    it 'should create a new branch' do
      post branches_path,
           params: { branch: { name: 'branch 2', phone_number: '0121212121211', district_ids: [@district2.id] } }
      expect(response).to have_http_status(:found)
      redirect_to(branches_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Branch was successfully created.')
    end

    it 'should render new template on invalid data' do
      post branches_path,
           params: { branch: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
      expect(flash.now[:alert]).to match(/Error: /)
    end
  end

  describe 'GET /edit' do
    it 'should be response successful' do
      get edit_branch_path(@branch)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the edit template' do
      get edit_branch_path(@branch)
      expect(response).to render_template(:edit)
    end

    it 'should include the form fields' do
      get edit_branch_path(@branch)
      expect(response.body).to include('Branch')
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'should update the branch and redirect to the branch show page with a notice' do
        patch branch_path(@branch),
              params: { branch: { name: 'branch 4' } }
        @branch.reload
        expect(@branch.name).to eq('branch 4')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(branch_path(@branch))
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Branch was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'should not update the branch and render the edit template with an alert' do
        patch branch_path(@branch),
              params: { branch: { name: '' } }
        @branch.reload
        expect(@branch.name).not_to eq('')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to match(/Error: /)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when deletion is successful' do
      it 'deletes the branch and redirects to the index page with a success notice' do
        expect do
          delete branch_path(@branch)
        end.to change(Branch, :count).by(-1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(branches_path)
        follow_redirect!
        expect(response.body).to include('Branch deleted successfully.')
      end
    end

    context 'when deletion is unsuccessful' do
      before do
        allow_any_instance_of(Branch).to receive(:destroy).and_return(false)
        allow_any_instance_of(Branch).to receive_message_chain(:errors, :full_messages).and_return(['Deletion failed due to dependencies.'])
      end

      it 'does not delete the branch and redirects to the index page with an error alert' do
        expect do
          delete branch_path(@branch)
        end.not_to change(Branch, :count)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(branches_path)
        follow_redirect!
        expect(response.body).to include('Deletion failed due to dependencies.')
      end
    end
  end
end
