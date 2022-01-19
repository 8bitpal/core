class AddListInformationToDelivery < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :delivery_list_id, :integer
    add_column :deliveries, :position, :integer
    add_index :deliveries, :delivery_list_id
  end
end
