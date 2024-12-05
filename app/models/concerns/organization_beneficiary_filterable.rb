module OrganizationBeneficiaryFilterable
  extend ActiveSupport::Concern

  class_methods do
    def apply_filters(params)
      beneficiaries = OrganizationBeneficiary.all
      beneficiaries = filter_by_organization_name(beneficiaries, params[:organization_name])
      beneficiaries = filter_by_registration_no(beneficiaries, params[:registration_no])
      beneficiaries = filter_by_case_name(beneficiaries, params[:case_name])
      beneficiaries = filter_by_phone_number(beneficiaries, params[:phone_number])
      beneficiaries = filter_by_people_count(beneficiaries, params[:min_people], params[:max_people])
      beneficiaries = filter_by_date_range(beneficiaries, params[:start_date], params[:end_date])
      beneficiaries = filter_by_branch_id(beneficiaries, params[:branch_id])
      beneficiaries = filter_by_provided_food(beneficiaries, params[:provided_food])
      filter_by_location(beneficiaries, params[:district_id], params[:county_id], params[:sub_county_id])
    end

    private

    def filter_by_organization_name(beneficiaries, organization_name)
      if organization_name.present?
        beneficiaries.where('organization_name ILIKE ?',
                            "%#{organization_name}%")
      else
        beneficiaries
      end
    end

    def filter_by_registration_no(beneficiaries, registration_no)
      registration_no.present? ? beneficiaries.where('registration_no ILIKE ?', "%#{registration_no}%") : beneficiaries
    end

    def filter_by_case_name(beneficiaries, case_name)
      case_name.present? ? beneficiaries.where('case_name ILIKE ?', "%#{case_name}%") : beneficiaries
    end

    def filter_by_phone_number(beneficiaries, phone_number)
      phone_number.present? ? beneficiaries.where('phone_number ILIKE ?', "%#{phone_number}%") : beneficiaries
    end

    def filter_by_people_count(beneficiaries, min_people, max_people)
      min_people = min_people.presence || 0
      max_people = max_people.presence || (min_people.to_i + 100)
      beneficiaries.where('(male + female) BETWEEN ? AND ?', min_people, max_people)
    end

    def filter_by_date_range(beneficiaries, start_date, end_date)
      if start_date.present? && end_date.present?
        beneficiaries.where(created_at: Date.parse(start_date)..Date.parse(end_date))
      else
        beneficiaries
      end
    end

    def filter_by_branch_id(beneficiaries, branch_id)
      branch_id.present? ? beneficiaries.where(branch_id:) : beneficiaries
    end

    def filter_by_provided_food(beneficiaries, provided_food)
      return beneficiaries unless provided_food.present?

      if provided_food == 'provided'
        beneficiaries.where('provided_food > 0')
      elsif provided_food == 'not_provided'
        beneficiaries.where('provided_food <= 0 OR provided_food IS NULL')
      else
        beneficiaries
      end
    end

    def filter_by_location(beneficiaries, district_id, county_id, sub_county_id)
      beneficiaries = beneficiaries.where(district_id:) if district_id.present?
      beneficiaries = beneficiaries.where(county_id:) if county_id.present?
      beneficiaries = beneficiaries.where(sub_county_id:) if sub_county_id.present?
      beneficiaries
    end
  end
end
