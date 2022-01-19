class RemoveDateFromDelivery < ActiveRecord::Migration[7.0]
  def up
    remove_column :deliveries, :date
  end

  def down
    add_column :deliveries, :date, :date
  end
end
