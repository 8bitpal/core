class DistributorFields < ActiveRecord::Migration[7.0]
  def up
    add_column :distributors, :invoice_threshold_cents, :integer, default: -500
    add_column :distributors, :currency, :string
    add_column :distributors, :fee, :float, default: 0.0175
    add_column :distributors, :separate_bucky_fee, :boolean, default: :true
  end

  def down
    remove_column :distributors, :separate_bucky_fee
    remove_column :distributors, :fee
    remove_column :distributors, :currency
    remove_column :distributors, :invoice_threshold_cents
  end
end
