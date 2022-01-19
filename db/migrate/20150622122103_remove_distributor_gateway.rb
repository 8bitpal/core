class RemoveDistributorGateway < ActiveRecord::Migration[7.0]
  def up
    drop_table :distributor_gateways
  end
end
