class AddExtrasPackageIdToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :extras_package_id, :integer
  end
end
