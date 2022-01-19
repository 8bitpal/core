class AddOldDeliveryToDelivery < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :old_delivery_id, :integer
  end
end
