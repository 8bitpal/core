class AddNameAndUrlToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :name, :string
    add_column :distributors, :url, :string
  end
end
