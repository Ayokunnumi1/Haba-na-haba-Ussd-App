module InventoryLoader
  extend ActiveSupport::Concern

  included do
    before_action :set_pagination_params, only: [:index]
  end

  def load_inventories
    load_inventory_list
    calculate_weekly_food_inventory
    calculate_weekly_cash_inventory
    calculate_weekly_cloth_inventory
  end

  def load_inventory_stock_alert
    @inventory_stock_alert = inventory_base_query.includes(:request).low_stock
  end

  def calculate_weekly_food_inventory
    start_of_week = Time.current.beginning_of_week
    end_of_week = Time.current.end_of_week
    inventory_base_query.where(donation_type: 'food', created_at: start_of_week..end_of_week).count
  end

  def calculate_weekly_cash_inventory
    start_of_week = Time.current.beginning_of_week
    end_of_week = Time.current.end_of_week
    inventory_base_query.where(donation_type: 'cash', created_at: start_of_week..end_of_week).sum(:collection_amount)
  end

  def calculate_weekly_cloth_inventory
    start_of_week = Time.current.beginning_of_week
    end_of_week = Time.current.end_of_week
    inventory_base_query.where(donation_type: 'cloth', created_at: start_of_week..end_of_week).count
  end

 def load_inventory_list
  begin
    @inventories = if @per_page.zero?
                    load_all_inventories
                  else
                    load_paginated_inventories
                  end
  rescue => e
    Rails.logger.error("Error loading inventories: #{e.message}")
    @inventories = Inventory.none # Fallback to empty collection
  end
end

  def load_all_inventories
    inventory_base_query.includes(:request)
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
    inventory_base_query.includes(:request)
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
    @total_inventory_count = inventory_base_query.count
    @weekly_food_inventory_count = calculate_weekly_food_inventory
    @weekly_cash_inventory_count = calculate_weekly_cash_inventory
    @weekly_cloth_inventory_count = calculate_weekly_cloth_inventory
  end

  def load_filters
    @total_pages = @per_page.zero? ? 1 : (inventory_base_query.count.to_f / @per_page).ceil
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

  private

  def inventory_base_query
    case current_user.role
    when 'super_admin', 'admin'
      Inventory.all
    when 'branch_manager', 'volunteer'
      Inventory.where(branch_id: current_user.branch_id)
    else
      Inventory.none # Fallback for unauthorized or guest users
    end
  end
end