class AddNewFieldsToRoutes < ActiveRecord::Migration[7.0]
  def change
    add_column :routes, :area_of_service, :text
    add_column :routes, :estimated_delivery_time, :text
  end
end
