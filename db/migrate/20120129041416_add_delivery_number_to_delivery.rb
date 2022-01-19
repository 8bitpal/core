class AddDeliveryNumberToDelivery < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :delivery_number, :integer
  end
end
