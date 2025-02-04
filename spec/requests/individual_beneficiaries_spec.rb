require 'rails_helper'

RSpec.describe 'IndividualBeneficiaries', type: :request do
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
    @county = @district.counties.create!(name: 'County 1')
    @sub_county = @county.sub_counties.create!(name: 'SubCounty 1')
    @branch = Branch.create!(name: 'Kampala Branch', phone_number: '0123456789', district_ids: [@district.id])
    @request1 = Request.create!(name: 'Request 1', phone_number: '010101010101', request_type: 'food_request',
                                residence_address: 'abc', is_selected: nil, district_id: @district.id,
                                branch_id: @branch.id, user_id: @user.id)
    @request2 = Request.create!(name: 'Request 2', phone_number: '010101010101', request_type: 'food_request',
                                residence_address: 'abc', is_selected: nil, district_id: @district.id,
                                branch_id: @branch.id, user_id: @user.id)

    @individual_beneficiary = IndividualBeneficiary.create!(
      name: 'John Doe',
      age: 30,
      gender: 'male',
      residence_address: '123 Street',
      village: 'Village A',
      parish: 'Parish A',
      phone_number: '0123456789',
      case_name: 'Case 1',
      case_description: 'Case description',
      fathers_name: 'Father Name',
      mothers_name: 'Mother Name',
      sub_county_id: @sub_county.id,
      county_id: @county.id,
      district_id: @district.id,
      request_id: @request1.id,
      branch_id: @branch.id,
      provided_food: 10.5
    )

    sign_in @user
    get '/individual_beneficiaries'
  end

  describe 'GET /index' do
    it 'should be response successful' do
      expect(response).to have_http_status(:ok)
    end

    it 'should render the user index file' do
      expect(response).to render_template(:index)
    end

    it 'should include the placeholder' do
      expect(response.body).to include('John Doe')
    end
  end

  describe 'GET /show' do
    it 'should be response successful' do
      get individual_beneficiary_path(@individual_beneficiary)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the show template' do
      get individual_beneficiary_path(@individual_beneficiary)
      expect(response).to render_template(:show)
    end

    it 'should include the individual_beneficiary name' do
      get individual_beneficiary_path(@individual_beneficiary)
      expect(response.body).to include(@individual_beneficiary.name)
    end
  end

  describe 'GET /new' do
    it 'should be response successfull' do
      get new_request_individual_beneficiary_path(@request2)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the new file' do
      get new_request_individual_beneficiary_path(@request2)
      expect(response).to render_template(:new)
    end

    it 'should include the placeholder' do
      get new_request_individual_beneficiary_path(@request2)
      expect(response.body).to include('Branch')
    end
  end

  describe 'POST /create' do
    it 'should create a new request' do
      post request_individual_beneficiary_path(@request2),
           params: { individual_beneficiary: { name: 'John Doe',
                                               age: 30,
                                               gender: 'male',
                                               residence_address: '123 Street',
                                               village: 'Village A',
                                               parish: 'Parish A',
                                               phone_number: '0123456789',
                                               case_name: 'Case 1',
                                               case_description: 'Case description',
                                               fathers_name: 'Father Name',
                                               mothers_name: 'Mother Name',
                                               sub_county_id: @sub_county.id,
                                               county_id: @county.id,
                                               district_id: @district.id,
                                               request_id: @request2.id,
                                               branch_id: @branch.id,
                                               provided_food: 10.5 } }

      expect(response).to have_http_status(:found)
      redirect_to(individual_beneficiaries_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Individual Beneficiary was successfully created.')
    end

    it 'should render new template on invalid data' do
      post request_individual_beneficiary_path(@request2),
           params: { individual_beneficiary: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
      expect(flash.now[:alert]).to match(/Error: /)
    end
  end

  describe 'GET /edit' do
    it 'should be response successful' do
      get edit_request_individual_beneficiary_path(@request1)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the edit template' do
      get edit_request_individual_beneficiary_path(@request1)
      expect(response).to render_template(:edit)
    end

    it 'should include the form fields' do
      get edit_request_individual_beneficiary_path(@request1)
      expect(response.body).to include('Request')
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'should update the Individual Beneficiaries and redirect to the Individual Beneficiaries show page with a notice' do
        patch request_individual_beneficiary_path(@request1),
              params: { individual_beneficiary: { name: 'name 4' } }
        @individual_beneficiary.reload
        expect(@individual_beneficiary.name).to eq('name 4')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(individual_beneficiaries_path)
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Individual Beneficiary was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'should not update the Individual Beneficiaries and render the edit template with an alert' do
        patch request_individual_beneficiary_path(@request1),
              params: { individual_beneficiary: { name: '' } }
        @individual_beneficiary.reload
        expect(@individual_beneficiary.name).not_to eq('')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to match(/Error: /)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when deletion is successful' do
      it 'deletes the individual_beneficiary and redirects to the index page with a success notice' do
        expect do
          delete individual_beneficiary_path(@individual_beneficiary)
        end.to change(IndividualBeneficiary, :count).by(-1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(individual_beneficiaries_path)
        follow_redirect!
        expect(response.body).to include('Individual Beneficiary was successfully deleted.')
      end
    end

    context 'when deletion is unsuccessful' do
      before do
        allow_any_instance_of(IndividualBeneficiary).to receive(:destroy).and_return(false)
        allow_any_instance_of(IndividualBeneficiary).to receive_message_chain(:errors, :full_messages).and_return(['Deletion failed due to dependencies.'])
      end

      it 'does not delete the individual_beneficiary and redirects to the index page with an error alert' do
        expect do
          delete individual_beneficiary_path(@individual_beneficiary)
        end.not_to change(IndividualBeneficiary, :count)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(individual_beneficiaries_path)
        follow_redirect!
        expect(response.body).to include('Failed to delete Individual Beneficiary.')
      end
    end
  end
end
