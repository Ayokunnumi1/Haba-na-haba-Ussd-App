class BranchesController < ApplicationController
  load_and_authorize_resource
  include ErrorHandler
  before_action :authenticate_user!
  before_action :set_branch, only: %i[show edit update destroy]
  before_action :load_districts, only: %i[new edit create update]
  before_action :load_counties_for_branch, only: %i[edit create update]

  def index
    @branches = Branch.includes(:districts).order(created_at: :desc)
  end

  def show; end

  def new
    @branch = Branch.new
    @branches = Branch.all
    @counties = County.none
  end

  def edit; end

  def create
    @branch = Branch.new(branch_params)

    if @branch.save
      redirect_to @branch, notice: 'Branch was successfully created.'
    else
      render :new, alert: 'Failed to create branch.'
    end
  end

  def update
    if @branch.update(branch_params)
      redirect_to @branch, notice: 'Branch was successfully updated.'
    else
      render :edit, alert: 'Failed to update branch.'
    end
  end

  def destroy
    if @branch.destroy
      redirect_to branches_path, notice: 'Branch deleted successfully.'
    else
      redirect_to branches_path, alert: @branch.errors.full_messages.to_sentence
    end
  rescue StandardError => e
    redirect_to branches_path, alert: handle_destroy_error(e)
  end

  def load_counties
    district_ids = params[:district_ids].split(',')
    @counties = County.where(district_id: district_ids)

    render json: @counties.map { |county| { id: county.id, name: county.name } }
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: users_path)
  end

  private

  def set_branch
    @branch = Branch.includes(:districts).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to branches_url, alert: 'Branch not found.'
  end

  def branch_params
    params.require(:branch).permit(:name, :phone_number, district_ids: [])
  end

  def load_districts
    @districts = District.all
  end

  def load_counties_for_branch
    @counties = @branch&.districts&.any? ? County.where(district_id: @branch.districts.pluck(:id)) : County.none
  end
end
