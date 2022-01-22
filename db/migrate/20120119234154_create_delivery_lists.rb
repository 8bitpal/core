class CreateDeliveryLists < ActiveRecord::Migration[7.0]
  def change
    create_table :delivery_lists do |t|
      t.references :distributor
      t.date :date

      t.timestamps
    end
  end
end
