class AddCronTimesToDistributors < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :daily_lists_schedule, :text
    add_column :distributors, :auto_delivery_schedule, :text
  end
end
