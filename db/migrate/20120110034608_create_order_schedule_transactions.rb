class CreateOrderScheduleTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :order_schedule_transactions do |t|
      t.references :order
      t.text :schedule
      t.references :delivery

      t.timestamps
    end
  end
end
