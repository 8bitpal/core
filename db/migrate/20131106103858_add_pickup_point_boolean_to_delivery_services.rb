class AddPickupPointBooleanToDeliveryServices < ActiveRecord::Migration[7.0]
  def change
    add_column :delivery_services, :pickup_point, :boolean, default: false, null: false
  end
end
