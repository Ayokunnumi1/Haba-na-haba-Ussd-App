class IndividualBeneficiariesController < ApplicationController
  before_action :set_request, only: [:new, :create, :edit, :update]
  before_action :set_individual_beneficiary, only: [:show, :edit, :update, :destroy]

  def index
    @individual_beneficiaries = IndividualBeneficiary.includes(:request).all
  end

  def show
  end

  def new
    if @request.individual_beneficiary.present?
      redirect_to individual_beneficiaries_path, alert: "Individual Beneficiary already exists for this request."
    else
      @individual_beneficiary = @request.build_individual_beneficiary
    end
  end

  def create
    @individual_beneficiary = @request.build_individual_beneficiary(individual_beneficiary_params)
    if @individual_beneficiary.save
      redirect_to individual_beneficiaries_path, notice: "Individual Beneficiary was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @individual_beneficiary.update(individual_beneficiary_params)
      redirect_to individual_beneficiaries_path, notice: "Individual Beneficiary was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @individual_beneficiary.destroy
      redirect_to individual_beneficiaries_path, notice: "Individual Beneficiary was successfully deleted."
    else
      redirect_to individual_beneficiaries_path, alert: "Failed to delete Individual Beneficiary."
    end
  rescue StandardError => e
    redirect_to individual_beneficiaries_path, alert: handle_destroy_error(e)
  end

  private

  def set_request
    @request = Request.find(params[:request_id]) if params[:request_id]
  end

  def set_individual_beneficiary
    @individual_beneficiary = IndividualBeneficiary.find(params[:id])
  end

  def individual_beneficiary_params
    params.require(:individual_beneficiary).permit(
      :name, :age, :gender, :residence_address, :village, :parish,
      :phone_number, :case_name, :case_description, :fathers_name,
      :mothers_name, :sub_county_id, :county_id, :district_id
    )
  end
end
