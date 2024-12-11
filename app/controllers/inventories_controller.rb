class InventoriesController < ApplicationController
  include Pagination

  before_action :set_request, only: %i[new create edit update]

  before_action :set_inventory, only: %i[edit update show destroy]

  def index
    set_pagination_params
    load_inventories
    calculate_counts
    load_filters
  end

  def show
    inventories = Inventory.includes(:request)
    @inventory = inventories.find(params[:id])
  end

  def new
    @inventory = @request.inventories.build(
      donor_name: @request.name,
      phone_number: @request.phone_number,
      district_id: @request.district_id,
      county_id: @request.county_id,
      sub_county_id: @request.sub_county_id,
      branch_id: @request.branch_id,
      residence_address: @request.residence_address
    )
    assign_inventory_partial(params[:type])
    load_location_data
    render :new
  end

  def create
    @inventory = @request.inventories.build(inventory_params)
    if @inventory.save
      redirect_to @inventory, notice: 'Inventory was successfully created.'
    else
      assign_inventory_partial(params[:inventory][:donation_type])
      load_location_data
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    assign_inventory_partial(@inventory.donation_type)
    @districts = District.all
    load_location_data
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to @inventory, notice: 'Inventory was successfully updated.'
    else
      assign_inventory_partial(@inventory.donation_type)
      load_location_data
      render :edit, status: :unprocessable_entity
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

  def set_pagination_params
    @per_page = params[:per_page].to_i
    @page_no = (params[:page] || 1).to_i
  end

  def load_inventories
    load_inventory_food
    load_inventory_cash_collected
    load_inventory_stock_alert
    load_inventory_expired
    load_inventory_list
  end

  def load_inventory_food
    @inventory_food = Inventory.includes(:request).by_food_name(params[:food_name])
  end

  def load_inventory_cash_collected
    @inventory_cash_collected = Inventory.includes(:request).by_collection_amount(params[:collection_amount])
  end

  def load_inventory_stock_alert
    @inventory_stock_alert = Inventory.includes(:request).low_stock
  end

  def load_inventory_expired
    @inventory_expired = Inventory.includes(:request).expired
  end

  def load_inventory_list
    @inventories = if @per_page.zero?
                     load_all_inventories
                   else
                     load_paginated_inventories
                   end
  end

  def load_all_inventories
    Inventory.includes(:request)
      .apply_filters(params).order(created_at: :desc)
      .by_donation_type(params[:donation_type])
      .by_donor_type(params[:donor_type])
      .by_collection_date(params[:collection_date])
      .by_place_of_collection(params[:place_of_collection])
      .by_branch(params[:branch_id])
      .order("#{sort_column} #{sort_direction}")
      .search_query(params[:query])
  end

  def load_paginated_inventories
    Inventory.includes(:request)
      .apply_filters(params).order(created_at: :desc)
      .by_donation_type(params[:donation_type])
      .by_donor_type(params[:donor_type])
      .by_collection_date(params[:collection_date])
      .by_place_of_collection(params[:place_of_collection])
      .by_branch(params[:branch_id])
      .search_query(params[:query])
      .order("#{sort_column} #{sort_direction}")
      .page(@page_no)
      .per(@per_page)
  end

  def calculate_counts
    @food_inventory_count = @inventory_food.count
    @total_cash_donated = @inventory_cash_collected.sum(:collection_amount)
    @low_stock_count = @inventory_stock_alert.count
    @expired_food = @inventory_expired.count
  end

  def load_filters
    @total_pages = @per_page.zero? ? 1 : (Inventory.count.to_f / @per_page).ceil
    @min_collection_amount = @inventories.minimum(:collection_amount) || 0
    @max_collection_amount = @inventories.maximum(:collection_amount) || 1500

    @request = Request.new
    @districts = District.all
    @counties = County.all
    @branches = Branch.all
    @sub_counties = SubCounty.all
  end

  def assign_inventory_partial(type)
    @inventory_partial = case type
                         when 'cash'
                           'inventories/collection_forms/cash_collection_form'
                         when 'food'
                           'inventories/collection_forms/food_collection_form'
                         when 'cloth'
                           'inventories/collection_forms/cloth_collection_form'
                         when 'other_items'
                           'inventories/collection_forms/other_items_collection_form'
                         else
                           'inventories/collection_forms/default_collection_form'
                         end
  end

  def load_location_data
    @districts = District.all
    @counties = @inventory.district.present? ? County.where(district_id: @inventory.district_id) : County.none
    @sub_counties = @inventory.county.present? ? SubCounty.where(county_id: @inventory.county_id) : SubCounty.none
    @branches = Branch.all
  end

  def set_request
    @request = Request.find(params[:request_id]) if params[:request_id]
  end

  def set_inventory
    @inventory = if @request
                   @request.inventories.find(params[:id])
                 else
                   Inventory.find(params[:id])
                 end
  end

  def inventory_params
    params.require(:inventory).permit(:donor_name, :donor_type, :collection_date, :food_name,
                                      :expire_date, :place_of_collection, :residence_address, :phone_number,
                                      :amount, :district_id, :county_id, :sub_county_id, :request_id,
                                      :branch_id, :collection_amount, :food_quantity, :cloth_condition, :cloth_name,
                                      :cloth_size, :cloth_quantity, :food_type, :donation_type, :cost_of_food, :cloth_type,
                                      :family_member_count, :family_name, :organization_name, :organization_contact_person,
                                      :organization_contact_phone, :other_items_name, :other_items_condition,
                                      :other_items_quantity)
  end

  def sort_column
    Inventory.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
