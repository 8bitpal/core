class AddSpecialOrderPreferenceToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :special_order_preference, :text
  end
end
