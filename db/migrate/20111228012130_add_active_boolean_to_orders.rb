class AddActiveBooleanToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :active, :boolean, default: true, null: false
  end
end
