class CreateCronLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :cron_logs do |t|
      t.text :log

      t.timestamps
    end
  end
end
