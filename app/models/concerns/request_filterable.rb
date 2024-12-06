module RequestFilterable
  extend ActiveSupport::Concern

  class_methods do
    def apply_filters(params)
      requests = Request.all
      requests = filter_by_name(requests, params[:name])
      requests = filter_by_phone_number(requests, params[:phone_number])
      requests = filter_by_request_type(requests, params[:request_type])
      requests = filter_by_location(requests, params[:district_id], params[:county_id], params[:sub_county_id])
      requests = filter_by_is_selected(requests, params[:is_selected])
      requests = filter_by_branch(requests, params[:branch_id])
      requests = filter_by_date_range(requests, params[:start_date], params[:end_date]) # rubocop:disable Style/RedundantAssignment
      requests

    end

    private

    def filter_by_name(requests, name)
      name.present? ? requests.where('name ILIKE ?', "%#{name}%") : requests
    end

    def filter_by_phone_number(requests, phone_number)
      phone_number.present? ? requests.where('phone_number ILIKE ?', "%#{phone_number}%") : requests
    end

    def filter_by_request_type(requests, request_type)
      request_type.present? ? requests.where('request_type ILIKE ?', "%#{request_type}%") : requests
    end

    def filter_by_location(requests, district_id, county_id, sub_county_id)
      requests = requests.where(district_id:) if district_id.present?
      requests = requests.where(county_id:) if county_id.present?
      requests = requests.where(sub_county_id:) if sub_county_id.present?
      requests
    end

    def filter_by_is_selected(requests, is_selected)
      is_selected.present? ? requests.where(is_selected:) : requests
    end

    def filter_by_branch(requests, branch_id)
      branch_id.present? ? requests.where(branch_id:) : requests
    end

    def filter_by_date_range(requests, start_date, end_date)
      if start_date.present? && end_date.present?
        requests.where(created_at: Date.parse(start_date)..Date.parse(end_date))
      else
        requests
      end
    end
  end
end
