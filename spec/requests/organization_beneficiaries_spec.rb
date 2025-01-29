require 'rails_helper'

RSpec.describe 'OrganizationBeneficiaries', type: :request do
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

    @organization_beneficiary = OrganizationBeneficiary.create!(
      organization_name: 'Organization B',
      male: 20,
      female: 30,
      adult_age_range: '25-60',
      children_age_range: '6-12',
      district_id: @district.id,
      county_id: @county.id,
      sub_county_id: @sub_county.id,
      residence_address: '456 Organization St.',
      village: 'Village B',
      parish: 'Parish B',
      phone_number: '1234567890',
      case_name: 'Case B',
      case_description: 'Description of Case B',
      registration_no: 'REG456',
      organization_no: 'ORG789',
      directors_name: 'Director B',
      head_of_institution: 'Head B',
      number_of_meals_home: 3,
      basic_FEH: false,
      request_id: @request1.id,
      branch_id: @branch.id,
      provided_food: 75.0,
      event_id: 2
    )

    sign_in @user
    get '/organization_beneficiaries'
  end

  describe 'GET /index' do
    it 'should be response successful' do
      expect(response).to have_http_status(:ok)
    end

    it 'should render the user index file' do
      expect(response).to render_template(:index)
    end

    it 'should include the placeholder' do
      expect(response.body).to include('Organization B')
    end
  end

  describe 'GET /show' do
    it 'should be response successful' do
      get organization_beneficiary_path(@organization_beneficiary)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the show template' do
      get organization_beneficiary_path(@organization_beneficiary)
      expect(response).to render_template(:show)
    end

    it 'should include the organization_beneficiary name' do
      get organization_beneficiary_path(@organization_beneficiary)
      expect(response.body).to include('Organization B')
    end
  end

  describe 'GET /new' do
    it 'should be response successfull' do
      get new_request_organization_beneficiary_path(@request2)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the new file' do
      get new_request_organization_beneficiary_path(@request2)
      expect(response).to render_template(:new)
    end

    it 'should include the placeholder' do
      get new_request_organization_beneficiary_path(@request2)
      expect(response.body).to include('Branch')
    end
  end

  describe 'POST /create' do
    it 'should create a new request' do
      post request_organization_beneficiary_path(@request2),
           params: { organization_beneficiary: { organization_name: 'Organization B',
                                                 male: 20,
                                                 female: 30,
                                                 adult_age_range: '25-60',
                                                 children_age_range: '6-12',
                                                 district_id: @district.id,
                                                 county_id: @county.id,
                                                 sub_county_id: @sub_county.id,
                                                 residence_address: '456 Organization St.',
                                                 village: 'Village B',
                                                 parish: 'Parish B',
                                                 phone_number: '1234567890',
                                                 case_name: 'Case B',
                                                 case_description: 'Description of Case B',
                                                 registration_no: 'REG456',
                                                 organization_no: 'ORG789',
                                                 directors_name: 'Director B',
                                                 head_of_institution: 'Head B',
                                                 number_of_meals_home: 3,
                                                 basic_FEH: false,
                                                 request_id: @request2.id,
                                                 branch_id: @branch.id,
                                                 provided_food: 75.0,
                                                 event_id: 2 } }

      expect(response).to have_http_status(:found)
      redirect_to(organization_beneficiaries_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Organization Beneficiary was successfully created.')
    end

    it 'should render new template on invalid data' do
      post request_organization_beneficiary_path(@request2),
           params: { organization_beneficiary: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
      expect(flash.now[:alert]).to match(/Error: /)
    end
  end

  describe 'GET /edit' do
    it 'should be response successful' do
      get edit_request_organization_beneficiary_path(@request1)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the edit template' do
      get edit_request_organization_beneficiary_path(@request1)
      expect(response).to render_template(:edit)
    end

    it 'should include the form fields' do
      get edit_request_organization_beneficiary_path(@request1)
      expect(response.body).to include('Request')
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'should update the organization Beneficiaries and redirect to the organization Beneficiaries show page with a notice' do
        patch request_organization_beneficiary_path(@request1),
              params: { organization_beneficiary: { organization_name: 'name 4' } }
        @organization_beneficiary.reload
        expect(@organization_beneficiary.organization_name).to eq('name 4')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(organization_beneficiary_path(@organization_beneficiary))
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Organization Beneficiary was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'should not update the organization Beneficiaries and render the edit template with an alert' do
        patch request_organization_beneficiary_path(@request1),
              params: { organization_beneficiary: { organization_name: '' } }
        @organization_beneficiary.reload
        expect(@organization_beneficiary.organization_name).not_to eq('')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to match(/Error: /)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when deletion is successful' do
      it 'deletes the organization_beneficiary and redirects to the index page with a success notice' do
        expect do
          delete organization_beneficiary_path(@organization_beneficiary)
        end.to change(OrganizationBeneficiary, :count).by(-1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(organization_beneficiaries_path)
        follow_redirect!
        expect(response.body).to include('Organization Beneficiary was successfully deleted.')
      end
    end

    context 'when deletion is unsuccessful' do
      before do
        allow_any_instance_of(OrganizationBeneficiary).to receive(:destroy).and_return(false)
        allow_any_instance_of(OrganizationBeneficiary).to receive_message_chain(:errors, :full_messages).and_return(['Deletion failed due to dependencies.'])
      end

      it 'does not delete the organization_beneficiary and redirects to the index page with an error alert' do
        expect do
          delete organization_beneficiary_path(@organization_beneficiary)
        end.not_to change(OrganizationBeneficiary, :count)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(organization_beneficiaries_path)
        follow_redirect!
        expect(response.body).to include('Failed to delete Organization Beneficiary.')
      end
    end
  end
end
