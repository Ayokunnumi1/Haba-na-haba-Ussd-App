module IndividualBeneficiaryFilterable
  extend ActiveSupport::Concern

  class_methods do
    def apply_filters(params)
      beneficiaries = IndividualBeneficiary.all
      beneficiaries = filter_by_name(beneficiaries, params[:name])
      beneficiaries = filter_by_case_name(beneficiaries, params[:case_name])
      beneficiaries = filter_by_gender(beneficiaries, params[:gender])
      beneficiaries = filter_by_phone_number(beneficiaries, params[:phone_number])
      beneficiaries = filter_by_age(beneficiaries, params[:min_age], params[:max_age])
      beneficiaries = filter_by_location(beneficiaries, params[:district_id], params[:county_id],
                                         params[:sub_county_id])
      filter_by_date_range(beneficiaries, params[:start_date], params[:end_date])
    end

    private

    def filter_by_name(beneficiaries, name)
      name.present? ? beneficiaries.where('name ILIKE ?', "%#{name}%") : beneficiaries
    end

    def filter_by_case_name(beneficiaries, case_name)
      case_name.present? ? beneficiaries.where('case_name ILIKE ?', "%#{case_name}%") : beneficiaries
    end

    def filter_by_gender(beneficiaries, gender)
      gender.present? ? beneficiaries.where('gender = ?', gender.capitalize) : beneficiaries
    end

    def filter_by_phone_number(beneficiaries, phone_number)
      phone_number.present? ? beneficiaries.where('phone_number ILIKE ?', "%#{phone_number}%") : beneficiaries
    end

    def filter_by_age(beneficiaries, min_age, max_age)
      if min_age.present? && max_age.present?
        beneficiaries.where(age: min_age..max_age)
      elsif min_age.present?
        beneficiaries.where('age >= ?', min_age)
      elsif max_age.present?
        beneficiaries.where('age <= ?', max_age)
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

    def filter_by_date_range(beneficiaries, start_date, end_date)
      if start_date.present? && end_date.present?
        beneficiaries.where(created_at: Date.parse(start_date)..Date.parse(end_date))
      else
        beneficiaries
      end
    end
  end
end
