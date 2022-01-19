class RemoveBuckyBoxPercentageFromDistributor < ActiveRecord::Migration[7.0]
  def change
    remove_column :distributors, :bucky_box_percentage
  end
end
