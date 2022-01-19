class AddDeliveryMethodToDelivery < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :delivery_method, :string
  end
end
