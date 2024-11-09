class SubCountiesController < ApplicationController
  include ErrorHandler
  before_action :authenticate_user!
  before_action :set_sub_county, only: %i[show edit update destroy]

  def index
    @sub_counties = SubCounty.all
    @sub_counties = SubCounty.page(params[:page]).per(20)
  end

  def show; end

  def new
    @sub_county = SubCounty.new
  end

  def create
    @sub_county = SubCounty.new(sub_county_params)

    if @sub_county.save
      redirect_to @sub_county, notice: 'SubCounty was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @sub_county.update(sub_county_params)
      redirect_to @sub_county, notice: 'SubCounty was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @sub_county.destroy
      redirect_to sub_counties_url, notice: 'SubCounty was successfully deleted.'
    else
      redirect_to sub_counties_url, alert: 'Failed to delete SubCounty.'
    end
  rescue StandardError => e
    redirect_to sub_counties_url, alert: handle_destroy_error(e)
  end

  private

  def set_sub_county
    @sub_county = SubCounty.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to sub_counties_url, alert: 'SubCounty not found.'
  end

  def sub_county_params
    params.require(:sub_county).permit(:name, :county_id)
  end
end
