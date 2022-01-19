class RemoveWebstoreCartPersistences < ActiveRecord::Migration[7.0]
  def change
    drop_table :webstore_cart_persistences
  end
end
