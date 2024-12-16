class HomeController < ApplicationController
  def index
    @request = Request.new
    @branches = Branch.all
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
  end

  def create_request
    @request = Request.new(request_params)

    if @request.save
      redirect_to root_path, notice: 'Request submitted successfully!'
    else
      @districts = District.all
      @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
      @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
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

  def load_branches
    if params[:district_id].present?
      branches = Branch.joins(:branch_districts)
        .where(branch_districts: { district_id: params[:district_id] })
      render json: branches.map { |branch| { id: branch.id, name: branch.name } }
    else
      render json: { error: 'District ID is required' }, status: :bad_request
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
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

  def request_params
    params.require(:request).permit(
      :name, :phone_number, :request_type, :residence_address,
      :is_selected, :district_id, :county_id, :sub_county_id,
      :branch_id
    )
  end
end
