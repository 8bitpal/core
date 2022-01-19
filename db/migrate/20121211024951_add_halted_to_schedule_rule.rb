class AddHaltedToScheduleRule < ActiveRecord::Migration[7.0]
  def change
    add_column :schedule_rules, :halted, :boolean, default: false
  end
end
