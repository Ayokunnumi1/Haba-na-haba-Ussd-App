require 'rails_helper'

RSpec.describe 'FamilyBeneficiaries', type: :request do
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

    @family_beneficiary = FamilyBeneficiary.create!(
      family_members: 5,
      male: 2,
      female: 3,
      children: 2,
      adult_age_range: '20-40',
      children_age_range: '5-12',
      district_id: @district.id,
      county_id: @county.id,
      sub_county_id: @sub_county.id,
      residence_address: '123 Family St.',
      village: 'Village X',
      parish: 'Parish Y',
      phone_number: '0123456789',
      case_name: 'Case Name',
      case_description: 'Description of the case.',
      fathers_name: 'Father John',
      mothers_name: 'Mother Mary',
      fathers_occupation: 'Farmer',
      mothers_occupation: 'Teacher',
      number_of_meals_home: 2,
      number_of_meals_school: 1,
      basic_FEH: true,
      basic_FES: true,
      request_id: @request1.id,
      branch_id: @branch.id,
      provided_food: 10.5,
      event_id: 1
    )

    sign_in @user
    get '/family_beneficiaries'
  end

  describe 'GET /index' do
    it 'should be response successful' do
      expect(response).to have_http_status(:ok)
    end

    it 'should render the user index file' do
      expect(response).to render_template(:index)
    end

    it 'should include the placeholder' do
      expect(response.body).to include('Father John')
    end
  end

  describe 'GET /show' do
    it 'should be response successful' do
      get family_beneficiary_path(@family_beneficiary)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the show template' do
      get family_beneficiary_path(@family_beneficiary)
      expect(response).to render_template(:show)
    end

    it 'should include the family_beneficiary name' do
      get family_beneficiary_path(@family_beneficiary)
      expect(response.body).to include('Father John')
    end
  end

  describe 'GET /new' do
    it 'should be response successfull' do
      get new_request_family_beneficiary_path(@request2)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the new file' do
      get new_request_family_beneficiary_path(@request2)
      expect(response).to render_template(:new)
    end

    it 'should include the placeholder' do
      get new_request_family_beneficiary_path(@request2)
      expect(response.body).to include('Branch')
    end
  end

  describe 'POST /create' do
    it 'should create a new request' do
      post request_family_beneficiary_path(@request2),
           params: { family_beneficiary: { family_members: 5,
                                           male: 2,
                                           female: 3,
                                           children: 2,
                                           adult_age_range: '20-40',
                                           children_age_range: '5-12',
                                           district_id: @district.id,
                                           county_id: @county.id,
                                           sub_county_id: @sub_county.id,
                                           residence_address: '123 Family St.',
                                           village: 'Village X',
                                           parish: 'Parish Y',
                                           phone_number: '0123456789',
                                           case_name: 'Case Name',
                                           case_description: 'Description of the case.',
                                           fathers_name: 'Father John',
                                           mothers_name: 'Mother Mary',
                                           fathers_occupation: 'Farmer',
                                           mothers_occupation: 'Teacher',
                                           number_of_meals_home: 2,
                                           number_of_meals_school: 1,
                                           basic_FEH: true,
                                           basic_FES: true,
                                           request_id: @request2.id,
                                           branch_id: @branch.id,
                                           provided_food: 10.5,
                                           event_id: 1 } }

      expect(response).to have_http_status(:found)
      redirect_to(family_beneficiaries_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Family Beneficiary was successfully created.')
    end

    it 'should render new template on invalid data' do
      post request_family_beneficiary_path(@request2),
           params: { family_beneficiary: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
      expect(flash.now[:alert]).to match(/Error: /)
    end
  end

  describe 'GET /edit' do
    it 'should be response successful' do
      get edit_request_family_beneficiary_path(@request1)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the edit template' do
      get edit_request_family_beneficiary_path(@request1)
      expect(response).to render_template(:edit)
    end

    it 'should include the form fields' do
      get edit_request_family_beneficiary_path(@request1)
      expect(response.body).to include('Request')
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'should update the Family Beneficiaries and redirect to the Family Beneficiaries show page with a notice' do
        patch request_family_beneficiary_path(@request1),
              params: { family_beneficiary: { fathers_name: 'name 4' } }
        @family_beneficiary.reload
        expect(@family_beneficiary.fathers_name).to eq('name 4')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(family_beneficiaries_path)
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Family Beneficiary was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'should not update the family Beneficiaries and render the edit template with an alert' do
        patch request_family_beneficiary_path(@request1),
              params: { family_beneficiary: { fathers_name: '' } }
        @family_beneficiary.reload
        expect(@family_beneficiary.fathers_name).not_to eq('')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to match(/Error: /)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when deletion is successful' do
      it 'deletes the family_beneficiary and redirects to the index page with a success notice' do
        expect do
          delete family_beneficiary_path(@family_beneficiary)
        end.to change(FamilyBeneficiary, :count).by(-1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(family_beneficiaries_path)
        follow_redirect!
        expect(response.body).to include('Family Beneficiary was successfully deleted.')
      end
    end

    context 'when deletion is unsuccessful' do
      before do
        allow_any_instance_of(FamilyBeneficiary).to receive(:destroy).and_return(false)
        allow_any_instance_of(FamilyBeneficiary).to receive_message_chain(:errors, :full_messages).and_return(['Deletion failed due to dependencies.'])
      end

      it 'does not delete the family_beneficiary and redirects to the index page with an error alert' do
        expect do
          delete family_beneficiary_path(@family_beneficiary)
        end.not_to change(FamilyBeneficiary, :count)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(family_beneficiaries_path)
        follow_redirect!
        expect(response.body).to include('Failed to delete Family Beneficiary.')
      end
    end
  end
end
