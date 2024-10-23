class InventoriesController < ApplicationController
  before_action :set_request, only: %i[new create edit update]
  before_action :set_inventory, only: %i[edit update show destroy]

  def index
    @inventories = Inventory.includes(:request).all
  end

  def show; end

  def new
    if @request.inventories.exists?
      redirect_to inventories_path, alert: 'Inventory already exists for this request.'
    else
      @inventory = @request.inventories.build
      @districts = District.all
      @counties = County.none
      @sub_counties = SubCounty.none
    end
  end

  def create
    if @request.inventories.exists?
      redirect_to @request, alert: 'An Inventory already exists for this request.'
    else
      @inventory = @request.inventories.build(inventory_params)
      if @inventory.save
        redirect_to @inventory, notice: 'Inventory was successfully created.'
      else
        @districts = District.all
        @counties = @inventory.district.present? ? County.where(district_id: @inventory.district_id) : County.none
        @sub_counties = @inventory.county.present? ? SubCounty.where(county_id: @inventory.county_id) : SubCounty.none
        render :new, alert: 'Failed to create the Inventory.'
      end
    end
  end

  def edit
    @districts = District.all
    @counties = @inventory.district.present? ? County.where(district_id: @inventory.district_id) : County.none
    @sub_counties = @inventory.county.present? ? SubCounty.where(county_id: @inventory.county_id) : SubCounty.none
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to @inventory, notice: 'Inventory was successfully updated.'
    else
      render :edit, alert: 'Failed to update the Inventory.'
    end
  end

  def destroy
    if @inventory.destroy
      redirect_to inventories_path, notice: 'Inventory was successfully deleted.'
    else
      redirect_to inventories_path, alert: 'Failed to delete Inventory.'
    end
  rescue StandardError => e
    redirect_to inventories_path, alert: handle_destroy_error(e)
  end

  def load_counties
    @counties = if params[:district_id].present?
                  County.where(district_id: params[:district_id])
                else
                  County.none
                end
    render json: @counties.map { |county| { id: county.id, name: county.name } }
  end

  def load_sub_counties
    @sub_counties = if params[:county_id].present?
                      SubCounty.where(county_id: params[:county_id])
                    else
                      SubCounty.none
                    end
    render json: @sub_counties.map { |sub_county| { id: sub_county.id, name: sub_county.name } }
  end

  private

  def set_request
    @request = Request.find(params[:request_id]) if params[:request_id]
  end

  def set_inventory
    if params[:request_id]
      @request = Request.find(params[:request_id])
      @inventory = @request.inventories.find(params[:id])
    else
      @inventory = Inventory.find(params[:id])
    end
  end

  def inventory_params
    params.require(:inventory).permit(:donor_name, :donor_type, :collection_date, :food_name,
                                      :expire_date, :village_address, :residence_address, :phone_number,
                                      :parish, :amount, :head_of_institution, :registration_no, :district_id,
                                      :county_id, :sub_county_id, :request_id)
  end
end
