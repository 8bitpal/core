class AddScheduleToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :schedule, :text
  end
end
