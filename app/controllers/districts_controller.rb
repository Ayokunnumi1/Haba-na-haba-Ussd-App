class DistrictsController < ApplicationController
  before_action :set_district, only: %i[show edit update destroy]

  def index
    @districts = Distirct.all
  end

  def show; end

  def new
    @distirct = Distirct.new
  end

  def create
    @distirct = District.new(district_params)

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
    @district.destroy
    redirect_to districts_url, notice: 'District was successfully destroyed.'
  end

  private

  def set_district
    @district = District.find(params[:id])
  end

  def district_params
    params.require(:district).permit(:name)
  end
end
