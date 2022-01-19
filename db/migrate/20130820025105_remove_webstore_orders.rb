class RemoveWebstoreOrders < ActiveRecord::Migration[7.0]
  def change
    drop_table :webstore_orders
  end
end
