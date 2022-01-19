class AddOverdueToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :overdue, :string, null: false, default: ""
  end
end
