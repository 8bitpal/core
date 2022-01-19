class AddIntercomIdToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :intercom_id, :string
  end
end
