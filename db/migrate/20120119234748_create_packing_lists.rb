class CreatePackingLists < ActiveRecord::Migration[7.0]
  def change
    create_table :packing_lists do |t|
      t.references :distributor
      t.date :date

      t.timestamps
    end
  end
end
