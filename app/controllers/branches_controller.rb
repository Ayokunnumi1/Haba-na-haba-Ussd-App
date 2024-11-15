class BranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_branch, only: %i[show edit update destroy]

  def index
    @branches = Branch.includes(:districts).all
  end

  def show; end

  def new
    @branch = Branch.new
    @branches = Branch.all
    @districts = District.all
    @counties = County.none
  end

  def edit
    @districts = District.all
    # Loading counties related to the branch’s associated districts
    @counties = @branch.districts.any? ? County.where(district_id: @branch.districts.pluck(:id)) : County.none
  end

  def create
    @branch = Branch.new(branch_params)

    if @branch.save
      redirect_to @branch, notice: 'Branch was successfully created.'
    else
      @districts = District.all
      @counties = @branch.districts.any? ? County.where(district_id: @branch.districts.pluck(:id)) : County.none
      render :new, alert: 'Failed to create branch.'
    end
  end

  def update
    if @branch.update(branch_params)
      redirect_to @branch, notice: 'Branch was successfully updated.'
    else
      @districts = District.all
      @counties = @branch.districts.any? ? County.where(district_id: @branch.districts.pluck(:id)) : County.none
      render :edit, alert: 'Failed to update branch.'
    end
  end

  def destroy
    if @branch.destroy
      redirect_to branches_url, notice: 'Branch was successfully deleted.'
    else
      redirect_to branches_url, alert: 'Failed to delete branch.'
    end
  rescue StandardError => e
    redirect_to branches_url, alert: handle_destroy_error(e)
  end

  def load_counties
    district_ids = params[:district_ids].split(',')
    @counties = County.where(district_id: district_ids)

    render json: @counties.map { |county| { id: county.id, name: county.name } }
  end

  private

  def set_branch
    @branch = Branch.includes(:districts).find(params[:id])
    @districts = District.all
  rescue ActiveRecord::RecordNotFound
    redirect_to branches_url, alert: 'Branch not found.'
  end

  def branch_params
    params.require(:branch).permit(:name, :phone_number, district_ids: [])
  end
end
