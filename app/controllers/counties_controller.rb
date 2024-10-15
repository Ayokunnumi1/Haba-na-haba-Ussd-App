class CountiesController < ApplicationController
  before_action :set_county, only: [:show, :edit, :update, :destroy]

  def index
    @counties = County.all
  end

  def show
  end

  def new
    @county = County.new
  end

  def create
    @county = County.new(county_params)

    if @county.save
      redirect_to @county, notice: 'County was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @county.update(county_params)
      redirect_to @county, notice: 'County was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @county.destroy
      redirect_to counties_url, notice: 'County was successfully deleted.'
    else
      redirect_to counties_url, alert: @county.errors.full_messages.to_sentence
    end
  rescue ActiveRecord::RecordNotDestroyed => e
    redirect_to counties_url, alert: "County could not be deleted: #{e.message}"
  end

  private

  def set_county
    @county = County.find(params[:id])
  end

  def county_params
    params.require(:county).permit(:name, :district_id)
  end
end
