class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :distributor, null: false
      t.string :event_category, null: false
      t.string :event_type, null: false
      t.integer :customer_id, null: true
      t.integer :invoice_id, null: true
      t.integer :reconciliation_id, null: true
      t.integer :transaction_id, null: true
      t.integer :delivery_id, null: true

      t.boolean :dismissed, null: false, default: false

      t.timestamps
    end

  end
end
