class AddUniquenessConstraintOnAddress < ActiveRecord::Migration[7.0]
  def change
    remove_index :addresses, :customer_id

    add_index :addresses, :customer_id, unique: true
  end
end
