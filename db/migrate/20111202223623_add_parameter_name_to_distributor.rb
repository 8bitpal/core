class AddParameterNameToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :parameter_name, :string
  end
end
