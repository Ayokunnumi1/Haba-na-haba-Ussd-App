class UpdateFamilyBeneficiaries < ActiveRecord::Migration[7.1]
  def change
    change_column_null :family_beneficiaries, :request_id, true

    add_reference :family_beneficiaries, :branch, foreign_key: true, null: true

    add_column :individual_beneficiaries, :provided_food, :integer
  end
end
