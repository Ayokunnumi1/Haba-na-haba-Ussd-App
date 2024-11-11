class DistrictsController < ApplicationController
  include ErrorHandler
  before_action :authenticate_user!
  before_action :set_district, only: %i[show edit update destroy]

  def index
    @districts = District.all
    @districts = District.page(params[:page]).per(20)
  end

  def show; end

  def new
    @district = District.new
  end

  def create
    @district = District.new(district_params)

    if @district.save
      redirect_to @district, notice: 'District was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @district.update(district_params)
      redirect_to @district, notice: 'District was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @district.destroy
      redirect_to districts_url, notice: 'District was successfully deleted.'
    else
      redirect_to districts_url, alert: @district.errors.full_messages.to_sentence
    end
  rescue StandardError => e
    redirect_to districts_url, alert: handle_destroy_error(e)
  end

  private

  def set_district
    @district = District.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to districts_url, alert: 'District not found.'
  end

  def district_params
    params.require(:district).permit(:name)
  end
end
