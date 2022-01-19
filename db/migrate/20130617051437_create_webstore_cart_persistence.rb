class CreateWebstoreCartPersistence < ActiveRecord::Migration[7.0]
  def change
    create_table :webstore_cart_persistences do |t|
      t.text :collected_data

      t.timestamps
    end
  end
end
