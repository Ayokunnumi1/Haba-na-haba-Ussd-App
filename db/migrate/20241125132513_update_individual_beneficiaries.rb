class UpdateIndividualBeneficiaries < ActiveRecord::Migration[7.1]
  def change
    change_column_null :individual_beneficiaries, :request_id, true

    add_reference :individual_beneficiaries, :branch, foreign_key: true, null: true

    add_column :individual_beneficiaries, :provided_food, :integer
  end
end
