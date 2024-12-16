class RemoveNullConstraintFromCountyAndSubCountyInRequests < ActiveRecord::Migration[7.1]
  def change
    change_column_null :requests, :county_id, true
    change_column_null :requests, :sub_county_id, true
  end
end
