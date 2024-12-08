class HomeController < ApplicationController
  layout 'home', only: [:index]

  def index
    @request = Request.new
    @branches = Branch.all
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
  end

  def edit
    @districts = District.all
    @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
    @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
    @branches = Branch.all
  end

  def create_request
    @request = Request.new(request_params)

    if @request.save
      redirect_to root_path, notice: "Request submitted successfully!"
    else
      @districts = District.all
      @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
      @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
    end
  end

  private

  def request_params
    params.require(:request).permit(
      :name, :phone_number, :request_type, :residence_address, 
      :is_selected, :district_id, :county_id, :sub_county_id, 
      :branch_id
    )
  end
end
