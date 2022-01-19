class AddFeatureSpendLimitToDistributors < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :feature_spend_limit, :boolean
  end
end
