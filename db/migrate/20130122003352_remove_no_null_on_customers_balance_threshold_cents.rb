class RemoveNoNullOnCustomersBalanceThresholdCents < ActiveRecord::Migration[7.0]
  def up
    change_column :customers, :balance_threshold_cents, :integer, null: true
  end

  def down
    change_column :customers, :balance_threshold_cents, :integer, null: false
  end
end
