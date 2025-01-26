require 'rails_helper'

RSpec.describe "Events", type: :request do
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
    context 'with valid parameters' do
      it 'creates a new event and redirects to its show page' do
        valid_params = {
          event: {
            name: 'New Event',
            start_date: Date.today,
            end_date: Date.today + 1.day,
            start_time: '10:00 AM',
            end_time: '12:00 PM',
            district_id: @district.id,
            county_id: @county.id,
            sub_county_id: @sub_county.id,
            user_ids: [@user.id]
          }
        }

        expect {
          post events_path, params: valid_params
        }.to change(Event, :count).by(1)
        
        expect(response).to redirect_to(event_path(Event.last))
        follow_redirect!
        expect(response.body).to include('Event and users were successfully created.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new event and renders the new template' do
        invalid_params = {
          event: {
            name: '', # Invalid as name is required
            start_date: nil,
            district_id: @district.id
          }
        }

        expect {
          post events_path, params: invalid_params
        }.not_to change(Event, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
        expect(response.body).to include('Error:')
      end
    end
  end

  describe 'GET /show' do
    it 'renders the show template' do
      get event_path(@event)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
      expect(response.body).to include(@event.name)
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
    context 'with valid parameters' do
      it 'updates the event and redirects to its show page' do
        valid_update_params = {
          event: { name: 'Updated Event Name' }
        }

        patch event_path(@event), params: valid_update_params
        @event.reload

        expect(@event.name).to eq('Updated Event Name')
        expect(response).to redirect_to(event_path(@event))
        follow_redirect!
        expect(response.body).to include('Event and users were successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the event and renders the edit template' do
        invalid_update_params = {
          event: { name: '' } # Invalid as name is required
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
      expect {
        delete event_path(@another_event)
      }.to change(Event, :count).by(-1)

      expect(response).to redirect_to(events_path)
      follow_redirect!
      expect(response.body).to include('Event was successfully deleted.')
    end
  end
end
