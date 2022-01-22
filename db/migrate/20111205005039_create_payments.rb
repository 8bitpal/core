class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :distributor
      t.references :customer
      t.references :account
      t.integer :amount_cents, default: 0, null: false
      t.string :currency
      t.string :kind
      t.text :description

      t.timestamps
    end
  end
end
