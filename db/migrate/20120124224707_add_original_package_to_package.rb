class AddOriginalPackageToPackage < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :original_package_id, :integer
    add_index :packages, :original_package_id
  end
end
