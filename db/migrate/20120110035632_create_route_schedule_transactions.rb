class CreateRouteScheduleTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :route_schedule_transactions do |t|
      t.references :route
      t.text :schedule

      t.timestamps
    end
    add_index :route_schedule_transactions, :route_id
  end
end
