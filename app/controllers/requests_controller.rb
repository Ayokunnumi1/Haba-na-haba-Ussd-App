class RequestsController < ApplicationController
  include RequestHelper

  before_action :set_request, only: %i[show edit update destroy]

  def index
    @requests = Request.all
  end

  def donor
    @requests = Request.where(request_type: 'donation')

    @donation_requests = Request.by_request_type('donation')
     .order("#{sort_column} #{sort_direction}")

    # Other instance variables as needed
  end

  def show; end

  def new
    @request = Request.new
    @districts = District.all
    @counties = County.none
    @branches = Branch.none
    @sub_counties = SubCounty.none
  end

  def edit
    @districts = District.all
    @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
    @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
    @branches = @request.district.present? ? Branch.where(district_id: @request.district_id) : Branch.none
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
  rescue StandardError => e
    redirect_to requests_url, alert: handle_destroy_error(e)
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

  private

  def sort_column
    Request.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:name, :phone_number, :request_type, :district_id, :county_id, :sub_county_id,
                                    :branch_id)
  end
end
