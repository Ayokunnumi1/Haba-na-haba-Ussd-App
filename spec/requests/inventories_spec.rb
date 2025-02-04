require 'rails_helper'

RSpec.describe 'Inventories', type: :request do
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

    @inventory = Inventory.create!(
      donor_name: 'John Doe',
      donor_type: 'Individual',
      collection_date: '2025-01-01',
      food_name: 'Rice',
      expire_date: '2025-12-31',
      place_of_collection: 'City Warehouse',
      residence_address: '123 Main St',
      phone_number: '9876543210',
      amount: 100,
      district_id: @district.id,
      county_id: @county.id,
      sub_county_id: @sub_county.id,
      request_id: @request1.id,
      branch_id: @branch.id,
      collection_amount: 50,
      food_quantity: 200,
      cloth_condition: 'New',
      cloth_name: 'Shirt',
      cloth_size: 'M',
      cloth_quantity: 10,
      food_type: 'Cereal',
      donation_type: 'Food',
      cost_of_food: 500,
      cloth_type: 'Cotton',
      family_member_count: 4,
      family_name: 'Smith Family',
      organization_name: 'Charity Org',
      organization_contact_person: 'Jane Doe',
      organization_contact_phone: '1234567890',
      other_items_name: 'Toys',
      other_items_condition: 'New',
      other_items_quantity: 5
    )

    sign_in @user
    get '/inventories'
  end

  describe 'GET /index' do
    it 'should be response successful' do
      expect(response).to have_http_status(:ok)
    end

    it 'should render the user index file' do
      expect(response).to render_template(:index)
    end

    it 'should include the placeholder' do
      expect(response.body).to include('Inventories')
    end
  end

  describe 'GET /show' do
    it 'should be response successful' do
      get inventory_path(@inventory)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the show template' do
      get inventory_path(@inventory)
      expect(response).to render_template(:show)
    end

    it 'should include the inventory name' do
      get inventory_path(@inventory)
      expect(response.body).to include('John Doe')
    end
  end

  describe 'GET /new' do
    it 'should be response successfull' do
      get new_request_inventory_path(@request2)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the new file' do
      get new_request_inventory_path(@request2)
      expect(response).to render_template(:new)
    end

    it 'should include the placeholder' do
      get new_request_inventory_path(@request2)
      expect(response.body).to include('Branch')
    end
  end

  describe 'POST /create' do
    it 'should create a new request' do
      post request_inventories_path(@request2),
           params: { inventory: { donor_name: 'John Doe',
                                  donor_type: 'Individual',
                                  collection_date: '2025-01-01',
                                  food_name: 'Rice',
                                  expire_date: '2025-12-31',
                                  place_of_collection: 'City Warehouse',
                                  residence_address: '123 Main St',
                                  phone_number: '9876543210',
                                  amount: 100,
                                  district_id: @district.id,
                                  county_id: @county.id,
                                  sub_county_id: @sub_county.id,
                                  request_id: @request2.id,
                                  branch_id: @branch.id,
                                  collection_amount: 50,
                                  food_quantity: 200,
                                  cloth_condition: 'New',
                                  cloth_name: 'Shirt',
                                  cloth_size: 'M',
                                  cloth_quantity: 10,
                                  food_type: 'Cereal',
                                  donation_type: 'Food',
                                  cost_of_food: 500,
                                  cloth_type: 'Cotton',
                                  family_member_count: 4,
                                  family_name: 'Smith Family',
                                  organization_name: 'Charity Org',
                                  organization_contact_person: 'Jane Doe',
                                  organization_contact_phone: '1234567890',
                                  other_items_name: 'Toys',
                                  other_items_condition: 'New',
                                  other_items_quantity: 5 } }

      expect(response).to have_http_status(:found)
      redirect_to(inventories_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Inventory was successfully created.')
    end

    it 'should render new template on invalid data' do
      post request_inventories_path(@request2),
           params: { inventory: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /edit' do
    it 'should be response successful' do
      get edit_request_inventory_path(@request1, @inventory)
      expect(response).to have_http_status(:ok)
    end

    it 'should render the edit template' do
      get edit_request_inventory_path(@request1, @inventory)
      expect(response).to render_template(:edit)
    end

    it 'should include the form fields' do
      get edit_request_inventory_path(@request1, @inventory)
      expect(response.body).to include('Request')
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'should update the inventory and redirect to the inventory show page with a notice' do
        patch request_inventory_path(@request1, @inventory),
              params: { inventory: { donor_name: 'name 4' } }
        @inventory.reload
        expect(@inventory.donor_name).to eq('name 4')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(inventory_path(@inventory))
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Inventory was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'should not update the organization Beneficiaries and render the edit template with an alert' do
        patch request_inventory_path(@request1, @inventory),
              params: { inventory: { phone_number: 'asdf' } }
        @inventory.reload
        expect(@inventory.phone_number).not_to eq('asdf')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when deletion is successful' do
      it 'deletes the inventory and redirects to the index page with a success notice' do
        expect do
          delete inventory_path(@inventory)
        end.to change(Inventory, :count).by(-1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(inventories_path)
        follow_redirect!
        expect(response.body).to include('Inventory was successfully deleted.')
      end
    end

    context 'when deletion is unsuccessful' do
      before do
        allow_any_instance_of(Inventory).to receive(:destroy).and_return(false)
        allow_any_instance_of(Inventory).to receive_message_chain(:errors, :full_messages).and_return(['Deletion failed due to dependencies.'])
      end

      it 'does not delete the inventory and redirects to the index page with an error alert' do
        expect do
          delete inventory_path(@inventory)
        end.not_to change(Inventory, :count)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(inventories_path)
        follow_redirect!
        expect(response.body).to include('Failed to delete Inventory.')
      end
    end
  end
end
