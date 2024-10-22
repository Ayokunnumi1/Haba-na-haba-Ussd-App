class FamilyBeneficiariesController < ApplicationController
  before_action :set_request, only: %i[new create edit update]
  before_action :set_family_beneficiary, only: %i[edit update show destroy]

  def index; end

  def show; end

  def new; end

  def edit; end

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
                                               :number_of_meals_school, :basic_FEH, :basic_FES, :request_id)
  end
end
