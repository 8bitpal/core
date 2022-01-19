class AddOrderToPackage < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :order_id, :integer
    add_index :packages, :order_id
  end
end
