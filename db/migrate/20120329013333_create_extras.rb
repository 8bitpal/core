class CreateExtras < ActiveRecord::Migration[7.0]
  def change
    create_table :extras do |t|
      t.string :name
      t.string :unit
      t.integer :distributor_id
      t.integer :price_cents
      t.string :currency

      t.timestamps
    end
  end
end
