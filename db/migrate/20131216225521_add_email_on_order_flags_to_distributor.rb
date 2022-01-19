class AddEmailOnOrderFlagsToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :email_customer_on_new_webstore_order, :boolean, null: false, default: true
    add_column :distributors, :email_customer_on_new_order, :boolean, null: false, default: false
    add_column :distributors, :email_distributor_on_new_webstore_order, :boolean, null: false, default: false
  end
end
