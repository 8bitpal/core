class RemoveGateways < ActiveRecord::Migration[7.0]
  def change
    drop_table :gateways
  end
end
