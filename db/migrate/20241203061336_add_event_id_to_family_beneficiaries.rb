class AddEventIdToFamilyBeneficiaries < ActiveRecord::Migration[7.1]
  def change
    add_column :family_beneficiaries, :event_id, :integer
  end
end
