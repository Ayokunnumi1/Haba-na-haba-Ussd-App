class IndividualBeneficiariesController < ApplicationController
  before_action :set_request, only: %i[new create edit update]
  before_action :set_individual_beneficiary, only: %i[edit update show destroy]

  def index
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
    @branches = Branch.all
    @individual_beneficiaries = IndividualBeneficiary.includes(:event).all
    @individual_beneficiaries = IndividualBeneficiary.includes(:request).apply_filters(params)
  end

  def show; end

  def new
    if @request.individual_beneficiary.present?
      redirect_to individual_beneficiaries_path, alert: 'Individual Beneficiary already exists for this request.'
    else
      @individual_beneficiary = @request.build_individual_beneficiary
      @districts = District.all
      @counties = County.none
      @sub_counties = SubCounty.none
      @branches = Branch.all
    end
  end

  def create
    if @request.individual_beneficiary.present?
      redirect_to @request, alert: 'An Individual Beneficiary already exists for this request.'
    else
      @individual_beneficiary = @request.build_individual_beneficiary(individual_beneficiary_params)
      @individual_beneficiary.event_id = @request.event_id
      if @individual_beneficiary.save
        redirect_to @individual_beneficiary, notice: 'Individual Beneficiary was successfully created.'
      else
        @districts = District.all
        @counties = County.none
        @sub_counties = SubCounty.none
        @branches = Branch.all
        flash.now[:alert] = "Error: #{@individual_beneficiary.errors.full_messages.to_sentence}"
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    @districts = District.all
    @counties = if @individual_beneficiary.district.present?
                  County.where(district_id: @individual_beneficiary.district_id)
                else
                  County.none
                end
    @sub_counties = if @individual_beneficiary.county.present?
                      SubCounty.where(county_id: @individual_beneficiary.county_id)
                    else
                      SubCounty.none
                    end
    @branches = Branch.all
  end

  def update
    if @individual_beneficiary.update(individual_beneficiary_params)
      redirect_to individual_beneficiaries_path, notice: 'Individual Beneficiary was successfully updated.'
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
      @branches = Branch.all
      flash.now[:alert] = "Error: #{@individual_beneficiary.errors.full_messages.to_sentence}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @individual_beneficiary.destroy
      redirect_to individual_beneficiaries_path, notice: 'Individual Beneficiary was successfully deleted.'
    else
      redirect_to individual_beneficiaries_path, alert: 'Failed to delete Individual Beneficiary.'
    end
  rescue StandardError => e
    redirect_to individual_beneficiaries_path, alert: handle_destroy_error(e)
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

  def set_request
    @request = Request.find(params[:request_id]) if params[:request_id]
  end

  def set_individual_beneficiary
    if params[:request_id]
      @request = Request.find(params[:request_id])
      @individual_beneficiary = @request.individual_beneficiary
    else
      @individual_beneficiary = IndividualBeneficiary.find(params[:id])
    end
  end

  def individual_beneficiary_params
    params.require(:individual_beneficiary).permit(
      :name, :age, :gender, :residence_address, :village, :parish,
      :phone_number, :case_name, :case_description, :fathers_name,
      :mothers_name, :sub_county_id, :county_id, :district_id,
      :request_id, :branch_id, :provided_food, :event_id
    )
  end
end
