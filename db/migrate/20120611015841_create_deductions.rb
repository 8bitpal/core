class CreateDeductions < ActiveRecord::Migration[7.0]
  def change
    create_table :deductions do |t|
      t.references :distributor
      t.references :account, default: 0, null: false
      t.integer :amount_cents
      t.string :currency
      t.string :kind
      t.text :description
      t.boolean :reversed
      t.datetime :reversed_at
      t.integer :transaction_id
      t.integer :reversal_transaction_id
      t.string :source
      t.integer :deductable_id
      t.string :deductable_type

      t.timestamps
    end
  end
end
