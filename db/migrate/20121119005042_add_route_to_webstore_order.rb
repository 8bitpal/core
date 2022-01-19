class AddRouteToWebstoreOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :webstore_orders, :route_id, :integer
  end
end
