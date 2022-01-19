class AddStatusToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :status, :string, default: "trial", null: false
  end
end
