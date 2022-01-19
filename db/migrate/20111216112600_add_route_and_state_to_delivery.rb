class AddRouteAndStateToDelivery < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :status, :string
    add_column :deliveries, :route_id, :integer
    add_index :deliveries, :route_id
  end
end
