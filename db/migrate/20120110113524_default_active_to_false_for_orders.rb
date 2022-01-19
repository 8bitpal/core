class DefaultActiveToFalseForOrders < ActiveRecord::Migration[7.0]
  def up
    change_column :orders, :active, :boolean, default: false, null: false
  end

  def down
    change_column :orders, :active, :boolean, default: true, null: false
  end
end
