class AddMorePhoneNumbersToAddress < ActiveRecord::Migration[7.0]
  def change
    rename_column :addresses, :phone, :phone_1
    add_column :addresses, :phone_2, :string
    add_column :addresses, :phone_3, :string
  end
end
