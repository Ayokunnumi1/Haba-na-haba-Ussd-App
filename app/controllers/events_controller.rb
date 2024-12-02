class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = Event.all
  end

  def new
    @event = current_user.events.build
    @users = User.all
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      allocate_users_to_event(@event, params[:event][:user_ids])
      redirect_to @event, notice: 'Event and users were successfully created.'
    else
      @users = User.all
      render :new, status: :unprocessable_entity
    end
  end
  
  def show
    @event = Event.find(params[:id])
    @districts = District.all
    @counties = County.all
    @sub_counties = SubCounty.all
    @requests = @event.requests.includes(:district, :county, :sub_county, :branch)
  end
  
  

  def edit
    @users = User.all
  end

  def update
    if @event.update(event_params)
      allocate_users_to_event(@event, params[:event][:user_ids])
      redirect_to @event, notice: 'Event and users were successfully updated.'
    else
      @users = User.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @event.destroy
      redirect_to events_path, notice: 'Event was successfully deleted.'
    else
      redirect_to events_path, alert: 'Failed to delete the event.'
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :start_date, :end_date, :start_time, :end_time, :district_id, :county_id, :sub_county_id, user_ids: [])
  end

  # Method to allocate users to the event using the join table (EventUser)
  def allocate_users_to_event(event, user_ids)
    return if user_ids.nil? || user_ids.empty?

    user_ids.each do |user_id|
      EventUser.create(event_id: event.id, user_id: user_id)
    end
  end
end
