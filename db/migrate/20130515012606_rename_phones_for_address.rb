class RenamePhonesForAddress < ActiveRecord::Migration[7.0]
  def change
    rename_column :addresses, :phone_1, :mobile_phone
    rename_column :addresses, :phone_2, :home_phone
    rename_column :addresses, :phone_3, :work_phone
  end
end
