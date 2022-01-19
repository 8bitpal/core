class AddDefaultCurrencyToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :currency, :string
  end
end
