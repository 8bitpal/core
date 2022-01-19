class SidebardescriptionReplacesAboutUsAndDetails < ActiveRecord::Migration[7.0]
  def up
    add_column :distributors, :sidebar_description, :text
    Distributor.update_all("sidebar_description = (about || '\n' || details)")
  end

  def down
    remove_column :distributors, :sidebar_description
  end
end
