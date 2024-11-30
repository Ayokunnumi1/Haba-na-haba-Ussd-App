module UserFilterable
  extend ActiveSupport::Concern

  class_methods do
    def apply_filters(params)
      users = User.all
      users = filter_by_name(users, params[:name])
      users = filter_by_role(users, params[:role])
      users = filter_by_phone_number(users, params[:phone_number])
      users
    end

    private

    def filter_by_name(users, name)
      name.present? ? users.where('first_name ILIKE ? OR last_name ILIKE ?', "%#{name}%", "%#{name}%") : users
    end

    def filter_by_role(users, role)
      role.present? ? users.where('role ILIKE ?', "%#{role}%") : users
    end

    def filter_by_phone_number(users, phone_number)
      phone_number.present? ? users.where('phone_number ILIKE ?', "%#{phone_number}%") : users
    end
  end
end
