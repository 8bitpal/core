class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :distributor
      t.references :box
      t.references :customer
      t.integer :quantity, default: 1, null: false
      t.text :likes
      t.text :dislikes
      t.string :frequency, default: 'single', null: false
      t.boolean :completed, default: false, null: false

      t.timestamps
    end
  end
end
