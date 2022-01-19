class AddAvailableDailyToBoxes < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :available_daily, :boolean, default: false, null: false
  end
end
