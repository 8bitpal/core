class RemoveAvailableDailyFromBoxes < ActiveRecord::Migration[7.0]
  def up
    remove_column :boxes, :available_daily
  end

  def down
    add_column :boxes, :available_daily, :boolean
  end
end
