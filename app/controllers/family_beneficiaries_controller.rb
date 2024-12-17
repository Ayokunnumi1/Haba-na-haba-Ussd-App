class FamilyBeneficiariesController < ApplicationController
  load_and_authorize_resource
  before_action :set_request, only: %i[new create edit update]
  before_action :set_family_beneficiary, only: %i[edit update show destroy]

  def index
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
    @branches = Branch.all
    @family_beneficiaries = FamilyBeneficiary.includes(:event).all
    @family_beneficiaries = FamilyBeneficiary.includes(:request).apply_filters(params)
  end

  def show; end

  def new
    if @request.family_beneficiary.present?
      redirect_to family_beneficiaries_path, alert: 'Family Beneficiary already exists for this request.'
    else
      @family_beneficiary = @request.build_family_beneficiary
      @districts = District.all
      @counties = County.none
      @sub_counties = SubCounty.none
    end
  end

  def create
    if @request.family_beneficiary.present?
      redirect_to @request, alert: 'An Family Beneficiary already exists for this request.'
    else
      @family_beneficiary = @request.build_family_beneficiary(family_beneficiary_params)
      @family_beneficiary.event_id = @request.event_id
      if @family_beneficiary.save
        redirect_to @family_beneficiary, notice: 'Family Beneficiary was successfully created.'
      else
        @districts = District.all
        @counties = County.none
        @sub_counties = SubCounty.none
        @branches = Branch.all
        flash.now[:alert] = "Error: #{@family_beneficiary.errors.full_messages.to_sentence}"
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    @districts = District.all
    @counties = if @family_beneficiary.district.present?
                  County.where(district_id: @family_beneficiary.district_id)
                else
                  County.none
                end
    @sub_counties = if @family_beneficiary.county.present?
                      SubCounty.where(county_id: @family_beneficiary.county_id)
                    else
                      SubCounty.none
                    end
  end

  def update
    if @family_beneficiary.update(family_beneficiary_params)
      redirect_to family_beneficiaries_path, notice: 'Family Beneficiary was successfully updated.'
    else
      @districts = District.all
      @counties = if @family_beneficiary.district.present?
                    County.where(district_id: @family_beneficiary.district_id)
                  else
                    County.none
                  end
      @sub_counties = if @family_beneficiary.county.present?
                        SubCounty.where(county_id: @family_beneficiary.county_id)
                      else
                        SubCounty.none
                      end
      flash.now[:alert] = "Error: #{@family_beneficiary.errors.full_messages.to_sentence}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @family_beneficiary.destroy
      redirect_to family_beneficiaries_path, notice: 'Family Beneficiary was successfully deleted.'
    else
      redirect_to family_beneficiaries_path, alert: 'Failed to delete Family Beneficiary.'
    end
  rescue StandardError => e
    redirect_to family_beneficiaries_path, alert: handle_destroy_error(e)
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
    redirect_to family_beneficiaries_path
  end

  private

  def set_request
    @request = Request.find(params[:request_id]) if params[:request_id]
  end

  def set_family_beneficiary
    if params[:request_id]
      @request = Request.find(params[:request_id])
      @family_beneficiary = @request.family_beneficiary
    else
      @family_beneficiary = FamilyBeneficiary.find(params[:id])
    end
  end

  def family_beneficiary_params
    params.require(:family_beneficiary).permit(:family_members, :male, :female, :children, :adult_age_range,
                                               :children_age_range, :district_id, :county_id, :sub_county_id,
                                               :residence_address, :village, :parish, :phone_number, :case_name,
                                               :case_description, :fathers_name, :mothers_name,
                                               :fathers_occupation, :mothers_occupation, :number_of_meals_home,
                                               :number_of_meals_school, :basic_FEH, :basic_FES, :request_id, :branch_id, :provided_food, :event_id)
  end
end
