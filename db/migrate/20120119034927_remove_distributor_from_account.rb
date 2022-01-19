class RemoveDistributorFromAccount < ActiveRecord::Migration[7.0]
  def up
    remove_index :accounts, :distributor_id
    remove_column :accounts, :distributor_id
  end

  def down
    add_column :accounts, :distributor_id, :integer
    add_index :accounts, :distributor_id
  end
end
