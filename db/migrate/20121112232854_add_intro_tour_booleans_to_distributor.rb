class AddIntroTourBooleansToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :customers_show_intro, :boolean, default: true, null: false
    add_column :distributors, :deliveries_index_packing_intro, :boolean, default: true, null: false
    add_column :distributors, :deliveries_index_deliveries_intro, :boolean, default: true, null: false
    add_column :distributors, :payments_index_packing_intro, :boolean, default: true, null: false
  end
end
