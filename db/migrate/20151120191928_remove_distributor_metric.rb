class RemoveDistributorMetric < ActiveRecord::Migration[7.0]
  def change
    drop_table :distributor_metrics
  end
end
