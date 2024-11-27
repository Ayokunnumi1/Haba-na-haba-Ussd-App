module FamilyBeneficiaryFilterable
  extend ActiveSupport::Concern

  class_methods do
    def apply_filters(params)
      beneficiaries = FamilyBeneficiary.all
      beneficiaries = filter_by_father_name(beneficiaries, params[:fathers_name])
      beneficiaries = filter_by_mother_name(beneficiaries, params[:mothers_name])
      beneficiaries = filter_by_case_name(beneficiaries, params[:case_name])
      beneficiaries = filter_by_phone_number(beneficiaries, params[:phone_number])
      beneficiaries = filter_by_member_count(beneficiaries, params[:min_member], params[:max_member])
      beneficiaries = filter_by_date_range(beneficiaries, params[:start_date], params[:end_date])
      beneficiaries = filter_by_branch_id(beneficiaries, params[:branch_id])
      beneficiaries = filter_by_provided_food(beneficiaries, params[:provided_food])
      filter_by_location(beneficiaries, params[:district_id], params[:county_id], params[:sub_county_id])
    end

    private

    def filter_by_father_name(beneficiaries, fathers_name)
      fathers_name.present? ? beneficiaries.where('fathers_name ILIKE ?', "%#{fathers_name}%") : beneficiaries
    end

    def filter_by_mother_name(beneficiaries, mothers_name)
      mothers_name.present? ? beneficiaries.where('mothers_name ILIKE ?', "%#{mothers_name}%") : beneficiaries
    end

    def filter_by_case_name(beneficiaries, case_name)
      case_name.present? ? beneficiaries.where('case_name ILIKE ?', "%#{case_name}%") : beneficiaries
    end

    def filter_by_phone_number(beneficiaries, phone_number)
      phone_number.present? ? beneficiaries.where('phone_number ILIKE ?', "%#{phone_number}%") : beneficiaries
    end

    def filter_by_member_count(beneficiaries, min_member, max_member)
      if min_member.present? && max_member.present?
        beneficiaries.where(family_members: min_member..max_member)
      elsif min_member.present?
        beneficiaries.where('family_members >= ?', min_member)
      elsif max_member.present?
        beneficiaries.where('family_members <= ?', max_member)
      else
        beneficiaries
      end
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
