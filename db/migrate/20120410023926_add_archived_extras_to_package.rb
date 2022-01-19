class AddArchivedExtrasToPackage < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :archived_extras, :text
  end
end
