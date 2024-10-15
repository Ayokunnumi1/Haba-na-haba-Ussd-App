class DistrictsController < ApplicationController
  before_action :set_district, only: %i[show edit update destroy]

  def index
    @districts = District.all
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
  rescue ActiveRecord::RecordNotDestroyed => e
    redirect_to districts_url, alert: "District could not be deleted: #{e.message}"
  end

  private

  def set_district
    @district = District.find(params[:id])
  end

  def district_params
    params.require(:district).permit(:name)
  end
end
