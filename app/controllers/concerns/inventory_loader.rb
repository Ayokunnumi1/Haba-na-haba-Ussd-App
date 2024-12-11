module InventoryLoader
  extend ActiveSupport::Concern

  included do
    before_action :set_pagination_params, only: [:index]
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

  def load_location_data
    @districts = District.all
    @counties = @inventory.district.present? ? County.where(district_id: @inventory.district_id) : County.none
    @sub_counties = @inventory.county.present? ? SubCounty.where(county_id: @inventory.county_id) : SubCounty.none
    @branches = Branch.all
  end
end
