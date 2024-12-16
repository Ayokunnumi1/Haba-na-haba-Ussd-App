class RemoveCountyAndSubCountyIndexesOnRequests < ActiveRecord::Migration[7.1]
  def change
    remove_index :requests, :county_id if index_exists?(:requests, :county_id)
    remove_index :requests, :sub_county_id if index_exists?(:requests, :sub_county_id)    
  end
end
