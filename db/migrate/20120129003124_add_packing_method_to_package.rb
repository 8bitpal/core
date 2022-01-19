class AddPackingMethodToPackage < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :packing_method, :string
  end
end
