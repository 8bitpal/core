class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :customer
      t.string :address_1
      t.string :address_2
      t.string :suburb
      t.string :city
      t.string :postcode
      t.text :delivery_note

      t.timestamps
    end
  end
end
