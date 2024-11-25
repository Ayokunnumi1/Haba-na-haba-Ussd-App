class UpdateOrganizationBeneficiaries < ActiveRecord::Migration[7.1]
  def change
    change_column_null :organization_beneficiaries, :request_id, true

    add_reference :organization_beneficiaries, :branch, foreign_key: true, null, true

    add_column :organization_beneficiaries, :provided_food, :integer
  end
end
