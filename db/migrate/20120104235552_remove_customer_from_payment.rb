class RemoveCustomerFromPayment < ActiveRecord::Migration[7.0]
  def up
    remove_index :payments, :customer_id
    remove_column :payments, :customer_id
  end

  def down
    add_column :payments, :customer_id, :integer
    add_index :payments, :customer_id
  end
end
