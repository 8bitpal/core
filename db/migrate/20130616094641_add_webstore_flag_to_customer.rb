class AddWebstoreFlagToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :via_webstore, :boolean, default: false
  end
end
