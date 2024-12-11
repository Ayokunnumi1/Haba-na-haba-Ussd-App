module InventoriesFilterable
  extend ActiveSupport::Concern

  class_methods do
    def apply_filters(params)
      inventories = Inventory.all
      inventories = filter_by_name(inventories, params[:donor_name])
      inventories = filter_by_donation_type(inventories, params[:donation_type])
      inventories = filter_by_donor_type(inventories, params[:donor_type])
      inventories = filter_by_collection_date(inventories, params[:start_date], params[:end_date])
      inventories = filter_by_location(inventories, params[:district_id], params[:county_id], params[:sub_county_id])
      filter_by_branch(inventories, params[:branch_id])
    end

    private

    def filter_by_name(inventories, donor_name)
      donor_name.present? ? inventories.where('donor_name ILIKE ?', "%#{donor_name}%") : inventories
    end

    def filter_by_donation_type(inventories, donation_type)
      donation_type.present? ? inventories.where('donation_type ILIKE ?', "%#{donation_type}%") : inventories
    end

    def filter_by_donor_type(inventories, donor_type)
      donor_type.present? ? inventories.where('donor_type ILIKE ?', "%#{donor_type}%") : inventories
    end

    def filter_by_collection_date(inventories, start_date, end_date)
      if start_date.present? && end_date.present?
        inventories.where(collection_date: start_date..end_date)
      elsif start_date.present?
        inventories.where('collection_date >= ?', start_date)
      elsif end_date.present?
        inventories.where('collection_date <= ?', end_date)
      else
        inventories
      end
    end

    def filter_by_location(inventories, district_id, county_id, sub_county_id)
      inventories = inventories.where(district_id: district_id) if district_id.present?
      inventories = inventories.where(county_id: county_id) if county_id.present?
      inventories = inventories.where(sub_county_id: sub_county_id) if sub_county_id.present?
      inventories
    end

    def filter_by_branch(inventories, branch_id)
      branch_id.present? ? inventories.where(branch_id: branch_id) : inventories
    end
  end
end
