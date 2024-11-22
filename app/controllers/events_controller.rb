class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[:show, :edit, :update, :destroy]

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    event = Event.find(params[:id])
    # Delete the associated event_users first
    event.event_users.destroy_all
    # Then delete the event
    event.destroy
    redirect_to events_path, notice: 'Event was successfully deleted.'
  end

  def show
    # The set_event callback already sets @event
  end

  def edit
    # The set_event callback already sets @event
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :start_date, :end_date, :start_time, :end_time, :district_id, :county_id, :sub_county_id, user_ids: [])
  end
end
