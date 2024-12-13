class InventoriesController < ApplicationController
  load_and_authorize_resource
  include Pagination

  before_action :set_request, only: %i[new create edit update]
  before_action :set_inventory, only: %i[edit update show destroy]
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize

  def index
    @per_page = (params[:per_page] || 2).to_i
    @page_no = (params[:page] || 1).to_i
    @inventory_food = Inventory.includes(:request).by_food_type
    @inventory_donated = Inventory.includes(:request).donated
    @inventory_stock_alert = Inventory.includes(:request).stock_alert
    @inventory_expired = Inventory.includes(:request).expired

    @food_inventory_count = @inventory_food.count
    total_count = Inventory.count
    @total_pages = (total_count.to_f / @per_page).ceil

    @inventories = Inventory.includes(:request)
      .by_donation_type(params[:donor_type])
      .by_donation_date(params[:collection_date])
      .by_expire_range(params[:start_date], params[:end_date])
      .by_collection_amount(params[:min_amount], params[:max_amount])
      .order("#{sort_column} #{sort_direction}")
      .search_query(params[:query])
      .page(@page_no)
      .per(@per_page)

    @min_collection_amount = @inventories.minimum(:amount) || 0
    @max_collection_amount = @inventories.maximum(:amount) || 1500
    @inventories = Inventory.includes(:event).all

    @request = Request.new
    @districts = District.all
    @counties = County.none
    @branches = Branch.none
    @sub_counties = SubCounty.none
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  def show
    inventory = Inventory.find(params[:id])
    respond_to do |format|
      format.html { render partial: 'inventories/modal', locals: { inventory: @inventory } }
      format.json { render json: inventory }
    end
  end

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
      @inventory.event_id = @request.event_id
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

  def bulk_delete
    ids = params[:ids]
    Inventory.where(id: ids).destroy_all

    respond_to do |format|
      format.json { render json: { success: true, message: 'Items deleted successfully' } }
      format.html { redirect_to inventories_path, notice: 'Selected items were deleted.' }
    end
  end

  rescue_from CanCan::AccessDenied do |_|
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to inventories_path
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
                                      :county_id, :sub_county_id, :request_id,
                                      :branch_id, :collection_amount, :event_id)
  end

  def sort_column
    Inventory.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
