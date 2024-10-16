class BranchesController < ApplicationController
  before_action :set_branch, only: %i[show edit update destroy]

  def index
    @branches = Branch.all
  end

  def show; end

  def new
    @branch = Branch.new
  end

  def create
    @branch = Branch.new(branch_params)

    if @branch.save
      redirect_to @branch, notice: 'Branch was successfully created.'
    else
      render :new, alert: 'Failed to create branch.'
    end
  end

  def edit; end

  def update
    if @branch.update(branch_params)
      redirect_to @branch, notice: 'Branch was successfully updated.'
    else
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

  private

  def set_branch
    @branch = Branch.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to branches_url, alert: 'Branch not found.'
  end

  def branch_params
    params.require(:branch).permit(:name, :phone_number, :district_id, :county_id)
  end
end
