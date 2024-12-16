class EventsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :set_event, only: %i[show edit update destroy]
  before_action :initialize_event, only: %i[new create]
  before_action :set_form_dependencies, only: %i[new create edit update]

  def index
    @events = Event.all
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
  end

  def new; end

  def create
    @event.assign_attributes(event_params)

    if @event.save
      allocate_users_to_event(@event, params[:event][:user_ids])
      redirect_to @event, notice: 'Event and users were successfully created.'
    else
      set_form_dependencies
      flash.now[:alert] = "Error: #{@event.errors.full_messages.to_sentence}"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @branches = Branch.all
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
    @users = User.where(role: 'volunteer')
    @requests = @event.requests.includes(:district, :county, :sub_county, :branch)
  end

  def edit; end

  def update
    if @event.update(event_params)
      allocate_users_to_event(@event, params[:event][:user_ids])
      redirect_to @event, notice: 'Event and users were successfully updated.'
    else
      set_form_dependencies
      flash.now[:alert] = "Error: #{@event.errors.full_messages.to_sentence}"
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

  def load_counties
    @counties = if params[:district_id].present?
                  County.where(district_id: params[:district_id])
                else
                  County.none
                end
    render json: @counties.map { |county| { id: county.id, name: county.name } }
  end

  def load_sub_counties
    @sub_counties = if params[:county_id].present?
                      SubCounty.where(county_id: params[:county_id])
                    else
                      SubCounty.none
                    end
    render json: @sub_counties.map { |sub_county| { id: sub_county.id, name: sub_county.name } }
  end

  rescue_from CanCan::AccessDenied do |_|
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to events_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def initialize_event
    @event = Event.new
  end

  def event_params
    params.require(:event).permit(:name, :start_date, :end_date, :start_time, :end_time, :district_id, :county_id, :sub_county_id, user_ids: [])
  end

  def set_form_dependencies
    @users = User.all
    @districts = District.all
    @counties = @event.district.present? ? County.where(district_id: @event.district_id) : County.none
    @sub_counties = @event.county.present? ? SubCounty.where(county_id: @event.county_id) : SubCounty.none
  end

  # Method to allocate users to the event using the join table (EventUser)
  def allocate_users_to_event(event, user_ids)
    return if user_ids.nil? || user_ids.empty?

    user_ids.each do |user_id|
      EventUser.create(event_id: event.id, user_id: user_id)
    end
  end
end
