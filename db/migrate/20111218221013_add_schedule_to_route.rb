class AddScheduleToRoute < ActiveRecord::Migration[7.0]
  def change
    add_column :routes, :schedule, :text
  end
end
