class AddArchivedConsumerDeliveryFeeToPackage < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :archived_consumer_delivery_fee_cents, :integer, default: 0
  end
end
