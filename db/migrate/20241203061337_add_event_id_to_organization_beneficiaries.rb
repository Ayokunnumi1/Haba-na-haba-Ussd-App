class AddEventIdToOrganizationBeneficiaries < ActiveRecord::Migration[7.1]
  def change
    add_column :organization_beneficiaries, :event_id, :integer
  end
end
