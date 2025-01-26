require 'rails_helper'

RSpec.describe 'Events', type: :request do
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
    @county = @district.counties.create!(name: 'County 1')
    @sub_county = @county.sub_counties.create!(name: 'SubCounty 1')
    @branch = Branch.create!(name: 'Kampala Branch', phone_number: '0123456789', district_ids: [@district.id])

    @event = Event.create!(
      name: 'Event 1',
      start_date: Date.today,
      end_date: Date.today + 1.day,
      start_time: '10:00 AM',
      end_time: '12:00 PM',
      district_id: @district.id,
      county_id: @county.id,
      sub_county_id: @sub_county.id
    )

    @request1 = Request.create!(name: 'Request 1', phone_number: '010101010101', request_type: 'food_request',
                                residence_address: 'abc', is_selected: nil, district_id: @district.id,
                                branch_id: @branch.id, user_id: @user.id, event_id: @event.id, parish: 'parish 2')
    @request2 = Request.create!(name: 'Request 2', phone_number: '010101010101', request_type: 'food_request',
                                residence_address: 'abc', is_selected: nil, district_id: @district.id,
                                branch_id: @branch.id, user_id: @user.id, event_id: @event.id, parish: 'parish 2')

    sign_in @user
  end

  describe 'GET /index' do
    it 'renders the index template' do
      get events_path
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /new' do
    it 'renders the new template' do
      get new_event_path
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /create' do
    context 'with invalid parameters' do
      it 'does not create a new event and renders the new template' do
        invalid_params = {
          event: {
            name: '',
            start_date: nil,
            district_id: @district.id
          }
        }

        expect do
          post events_path, params: invalid_params
        end.not_to change(Event, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
        expect(response.body).to include('Error:')
      end
    end
  end

  describe 'GET /edit' do
    it 'renders the edit template' do
      get edit_event_path(@event)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH /update' do
    context 'with invalid parameters' do
      it 'does not update the event and renders the edit template' do
        invalid_update_params = {
          event: { name: '' }
        }

        patch event_path(@event), params: invalid_update_params
        @event.reload

        expect(@event.name).not_to eq('')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(response.body).to include('Error:')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes the event and redirects to the index page' do
      expect do
        delete event_path(@event)
      end.to change(Event, :count).by(-1)

      expect(response).to redirect_to(events_path)
      follow_redirect!
      expect(response.body).to include('Event was successfully deleted.')
    end
  end
end
