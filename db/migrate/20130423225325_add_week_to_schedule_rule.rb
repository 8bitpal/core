class AddWeekToScheduleRule < ActiveRecord::Migration[7.0]
  def change
    add_column :schedule_rules, :week, :integer, default: 0
  end
end
