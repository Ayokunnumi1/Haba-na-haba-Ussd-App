class RequestsController < ApplicationController
  include EnglishMenu
  before_action :set_request, only: %i[show edit update destroy]
  skip_before_action :verify_authenticity_token, only: [:ussd]

  def index
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
    @requests = Request.apply_filters(params).order(created_at: :desc)
  end

  def ussd
    phone_number = params[:phoneNumber]
    text = params[:text]

    @request = Request.all

    response = process_ussd(text, phone_number)
    render plain: response
  end

  def show; end

  def new
    @request = Request.new
    @branches = Branch.all
    @districts = District.all
    @counties = County.none
    @branches = Branch.none
    @sub_counties = SubCounty.none
  end

  def edit
    @request = Request.find(params[:id])
    @event = Event.find_by(id: params[:event_id])
    @districts = District.all
    @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
    @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
    @branches = Branch.all
  end

  def create
    @request = Request.new(request_params)

    if @request.save
      redirect_to @request, notice: 'Request was successfully created.'
    else
      @districts = District.all
      @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
      @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
    end
  end

  def update
    if @request.update(request_params)
      redirect_to @request, notice: 'Request was successfully updated.'
    else
      @districts = District.all
      @branches = Branch.all
      @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
      @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
      render :edit, alert: 'Failed to update request.'
    end
  end

  def destroy
    if @request.destroy
      redirect_to requests_url, notice: 'Request was successfully destroyed.'
    else
      redirect_to requests_url, alert: 'Failed to delete request.'
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

  def create_for_event
    @event = Event.find(params[:event_id])
    @request = @event.requests.new(request_params)

    if @request.save
      redirect_to event_path(@event), notice: "Request created successfully!"
    else
      render :new
    end
  end

  private

  def process_ussd(text, phone_number)
    EnglishMenu.process_menu(text, phone_number, session)
  end

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:name, :phone_number, :request_type,
                                    :residence_address, :is_selected, :district_id,
                                    :county_id, :sub_county_id,
                                    :branch_id, :event_id)
  end
end