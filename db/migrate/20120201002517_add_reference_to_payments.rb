class AddReferenceToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :reference, :string
  end
end
