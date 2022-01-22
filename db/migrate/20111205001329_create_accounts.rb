class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.references :distributor
      t.references :customer
      t.integer :balance_cents, default: 0, null: false
      t.string :currency

      t.timestamps
    end
  end
end
