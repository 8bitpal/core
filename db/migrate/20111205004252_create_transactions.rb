class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :account
      t.string :kind
      t.integer :amount_cents, default: 0, null: false
      t.string :currency
      t.text :description

      t.timestamps
    end
  end
end
