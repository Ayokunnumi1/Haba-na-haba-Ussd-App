class OrganizationBeneficiariesController < ApplicationController
  load_and_authorize_resource
  include ErrorHandler
  before_action :set_request, only: %i[new create edit update]
  before_action :set_organization_beneficiary, only: %i[edit update show destroy]

  def index
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
    @branches = Branch.all
    @organization_beneficiaries = OrganizationBeneficiary.includes(:event).all
    @organization_beneficiaries = OrganizationBeneficiary.includes(:request).apply_filters(params)
  end

  def show; end

  def new
    if @request.organization_beneficiary.present?
      redirect_to organization_beneficiaries_path, alert: 'Organization Beneficiary already exists for this request.'
    else
      @organization_beneficiary = @request.build_organization_beneficiary
      @districts = District.all
      @counties = County.none
      @sub_counties = SubCounty.none
    end
  end

  def create
    if @request.organization_beneficiary.present?
      redirect_to @request, alert: 'An Organization Beneficiary already exists for this request.'
    else
      @organization_beneficiary = @request.build_organization_beneficiary(organization_beneficiary_params)
      @organization_beneficiary.event_id = @request.event_id
      if @organization_beneficiary.save
        redirect_to @organization_beneficiary, notice: 'Organization Beneficiary was successfully created.'
      else
        @districts = District.all
        @counties = County.none
        @sub_counties = SubCounty.none
        @branches = Branch.all
        flash.now[:alert] = "Error: #{@organization_beneficiary.errors.full_messages.to_sentence}"
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    @districts = District.all
    @counties = if @organization_beneficiary.district.present?
                  County.where(district_id: @organization_beneficiary.district_id)
                else
                  County.none
                end
    @sub_counties = if @organization_beneficiary.county.present?
                      SubCounty.where(county_id: @organization_beneficiary.county_id)
                    else
                      SubCounty.none
                    end
  end

  def update
    if @organization_beneficiary.update(organization_beneficiary_params)
      redirect_to @organization_beneficiary, notice: 'Organization Beneficiary was successfully updated.'
    else
      @districts = District.all
      @counties = if @organization_beneficiary.district.present?
                    County.where(district_id: @organization_beneficiary.district_id)
                  else
                    County.none
                  end
      @sub_counties = if @organization_beneficiary.county.present?
                        SubCounty.where(county_id: @organization_beneficiary.county_id)
                      else
                        SubCounty.none
                      end

      flash.now[:alert] = "Error: #{@organization_beneficiary.errors.full_messages.to_sentence}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @organization_beneficiary.destroy
      redirect_to organization_beneficiaries_path, notice: 'Organization Beneficiary was successfully deleted.'
    else
      redirect_to organization_beneficiaries_path, alert: 'Failed to delete Organization Beneficiary.'
    end
  rescue StandardError => e
    redirect_to organization_beneficiaries_path, alert: handle_destroy_error(e)
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
    redirect_to organization_beneficiaries_path
  end

  private

  def set_request
    @request = Request.find(params[:request_id]) if params[:request_id]
  end

  def set_organization_beneficiary
    if params[:request_id]
      @request = Request.find(params[:request_id])
      @organization_beneficiary = @request.organization_beneficiary
    else
      @organization_beneficiary = OrganizationBeneficiary.find(params[:id])
    end
  end

  def organization_beneficiary_params
    params.require(:organization_beneficiary).permit(
      :organization_name, :male, :female, :adult_age_range, :children_age_range, :district_id, :county_id,
      :sub_county_id, :residence_address, :village, :parish, :phone_number, :case_name, :case_description,
      :registration_no, :organization_no, :directors_name, :head_of_institution, :number_of_meals_home, :basic_FEH,
      :request_id, :branch_id, :provided_food, :event_id
    )
  end
end
