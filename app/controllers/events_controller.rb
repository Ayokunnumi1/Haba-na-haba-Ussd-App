class EventsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = Event.all
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
  end

  def new
    @event = Event.new
    @users = User.all
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      allocate_users_to_event(@event, params[:event][:user_ids])
      redirect_to @event, notice: 'Event and users were successfully created.'
    else
      @users = User.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @branches = Branch.all
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
    @requests = @event.requests.includes(:district, :county, :sub_county, :branch)
  end

  def edit
    @users = User.all
    @request = Request.find_by(id: params[:id])
    @districts = District.all
    @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
    @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
  end

  def update
    if @event.update(event_params)
      allocate_users_to_event(@event, params[:event][:user_ids])
      redirect_to @event, notice: 'Event and users were successfully updated.'
    else
      @users = User.all
      @districts = District.all
      @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
      @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
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
