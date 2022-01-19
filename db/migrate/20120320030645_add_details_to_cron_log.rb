class AddDetailsToCronLog < ActiveRecord::Migration[7.0]
  def change
    add_column :cron_logs, :details, :text
  end
end
