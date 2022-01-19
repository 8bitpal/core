class AddCustomerCanEditOrdersToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :customer_can_edit_orders, :boolean, null: false, default: true
  end
end
