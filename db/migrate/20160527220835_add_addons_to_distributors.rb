class AddAddonsToDistributors < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :addons, :string, null: false, default: ''
  end
end
