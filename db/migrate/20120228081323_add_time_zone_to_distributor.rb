class AddTimeZoneToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :time_zone, :string
  end
end
