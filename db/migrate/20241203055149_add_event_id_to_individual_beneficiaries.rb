class AddEventIdToIndividualBeneficiaries < ActiveRecord::Migration[7.1]
  def change
    add_column :individual_beneficiaries, :event_id, :integer
  end
end
