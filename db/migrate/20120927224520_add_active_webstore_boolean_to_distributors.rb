class AddActiveWebstoreBooleanToDistributors < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :active_webstore, :boolean, default: false, null: false
  end
end
