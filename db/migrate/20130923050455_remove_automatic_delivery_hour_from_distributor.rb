class RemoveAutomaticDeliveryHourFromDistributor < ActiveRecord::Migration[7.0]
  def change
    remove_column :distributors, :automatic_delivery_hour
  end
end
