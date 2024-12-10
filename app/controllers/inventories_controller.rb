class InventoriesController < ApplicationController
  include Pagination

  before_action :set_request, only: %i[ new create edit update]
 
  before_action :set_inventory, only: %i[edit update show destroy]
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def index
    @per_page = params[:per_page].to_i
    @page_no = (params[:page] || 1).to_i
    @inventory_food = Inventory.includes(:request).by_food_type
    @inventory_donated = Inventory.includes(:request).donated
    @inventory_stock_alert = Inventory.includes(:request).stock_alert
    @inventory_expired = Inventory.includes(:request).expired

    @food_inventory_count = @inventory_food.count

    # Check if 'Show All' is selected (per_page is 0)
    @inventories = if @per_page.zero?
                     Inventory.includes(:request)
                       .by_donation_type(params[:donation_type])
                       .by_donor_type(params[:donor_type])
                       .by_collection_date(params[:collection_date])
                       .by_place_of_collection(params[:place_of_collection])
                       .by_branch(params[:branch_id])                       
                       .order("#{sort_column} #{sort_direction}")
                       .search_query(params[:query])
                   else
                     Inventory.includes(:request)
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

    @total_pages = @per_page.zero? ? 1 : (Inventory.count.to_f / @per_page).ceil
    @min_collection_amount = @inventories.minimum(:amount) || 0
    @max_collection_amount = @inventories.maximum(:amount) || 1500

    @request = Request.new
    @districts = District.all
    @counties = County.none
    @branches = Branch.none
    @sub_counties = SubCounty.none
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
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
      set_inventory_partial(params[:type])
      @districts = District.all
      @counties = @inventory.district.present? ? County.where(district_id: @inventory.district_id) : County.none
      @sub_counties = @inventory.county.present? ? SubCounty.where(county_id: @inventory.county_id) : SubCounty.none
      @branches =  Branch.all  
      render :new      
  end

  def create    
      @inventory = @request.inventories.build(inventory_params)      
      if @inventory.save
        redirect_to @inventory, notice: 'Inventory was successfully created.'
      else
        Rails.logger.debug "params[:inventory][:donation_type]: #{params[:inventory][:donation_type]}"
        set_inventory_partial(params[:inventory][:donation_type])
        Rails.logger.debug "@inventory_partial: #{@inventory_partial}"
        @districts = District.all
        @counties = @inventory.district.present? ? County.where(district_id: @inventory.district_id) : County.none
        @sub_counties = @inventory.county.present? ? SubCounty.where(county_id: @inventory.county_id) : SubCounty.none
        @branches =  Branch.all        
        render :new, status: :unprocessable_entity
      end  
  end

  def edit
    @districts = District.all
    @counties = @inventory.district.present? ? County.where(district_id: @inventory.district_id) : County.none
    @sub_counties = @inventory.county.present? ? SubCounty.where(county_id: @inventory.county_id) : SubCounty.none
    @branches =  Branch.all
    set_inventory_partial(@inventory.donation_type)    
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to @inventory, notice: 'Inventory was successfully updated.'
    else
      set_inventory_partial(@inventory.donation_type)
      @districts = District.all
      @counties = @inventory.district.present? ? County.where(district_id: @inventory.district_id) : County.none
      @sub_counties = @inventory.county.present? ? SubCounty.where(county_id: @inventory.county_id) : SubCounty.none
      @branches = Branch.all
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

   def set_inventory_partial(type)
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
