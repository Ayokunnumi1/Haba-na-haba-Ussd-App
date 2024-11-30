class DistrictsController < ApplicationController
  include ErrorHandler
  before_action :authenticate_user!
  before_action :set_district, only: %i[show edit update destroy]

  def index
    @districts = District.includes(counties: :sub_counties).order(created_at: :desc)
  end

  def new
    @district = District.new
    @district.counties.build.sub_counties.build
  end

  def create
    @district = District.new(district_params)

    if @district.save
      redirect_to districts_path, notice: 'District, Counties, and SubCounties were successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @district = District.find(params[:id])
  end

  def update
    if @district.update(district_params)
      redirect_to districts_path, notice: 'District, Counties, and SubCounties were successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @district.destroy
      redirect_to districts_path, notice: 'District was successfully deleted.'
    else
      redirect_to districts_path, alert: @district.errors.full_messages.to_sentence
    end
  rescue StandardError => e
    redirect_to districts_path, alert: handle_destroy_error(e)
  end

  private

  def set_district
    @district = District.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to districts_path, alert: 'District not found.'
  end

  def district_params
    params.require(:district).permit(
      :name,
      counties_attributes: [
        :id, :name, :_destroy,
        sub_counties_attributes: [:id, :name, :_destroy]
      ]
    )
  end
end
