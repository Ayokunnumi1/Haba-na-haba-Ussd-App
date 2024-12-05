class RemoveCountyIdFromBranches < ActiveRecord::Migration[7.1]
  def change
    remove_column :branches, :county_id, :bigint
  end
end
