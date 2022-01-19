class AddContactNameToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :contact_name, :string
  end
end
