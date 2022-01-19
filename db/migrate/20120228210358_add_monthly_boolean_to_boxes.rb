class AddMonthlyBooleanToBoxes < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :available_monthly, :boolean, default: false, null: false
  end
end
