class AddCityToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :city, :string
  end
end
