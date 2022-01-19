class AddCustomerFields < ActiveRecord::Migration[7.0]
  def up
    add_column :customers, :distributor_id, :integer
    add_column :customers, :number, :string
  end

  def down
    remove_column :customers, :number
    remove_column :customers, :distributor_id
  end
end
