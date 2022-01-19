class AddNotifyAddressChangeToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :notify_address_change, :boolean
  end
end
