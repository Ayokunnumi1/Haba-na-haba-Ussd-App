class BranchesController < ApplicationController
  include ErrorHandler
  before_action :authenticate_user!
  before_action :set_branch, only: %i[show edit update destroy]
  before_action :load_districts, only: %i[new edit create update]

  def index
    @branches = Branch.includes(:districts).order(created_at: :desc)
  end

  def show; end

  def new
    @branch = Branch.new
    @districts = District.left_joins(:branch_districts)
                       .where(branch_districts: { id: nil })
  end

  def edit; end

  def create
    @branch = Branch.new(branch_params)

    if @branch.save
      redirect_to @branch, notice: 'Branch was successfully created.'
    else
      @districts = District.left_joins(:branch_districts)
      .where(branch_districts: { id: nil })
      flash.now[:alert] = "Error: #{@branch.errors.full_messages.to_sentence}"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @branch.update(branch_params)
      redirect_to @branch, notice: 'Branch was successfully updated.'
    else
      flash.now[:alert] = "Error: #{@branch.errors.full_messages.to_sentence}"
      render :edit, status: :unprocessable_entity
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
  
end
