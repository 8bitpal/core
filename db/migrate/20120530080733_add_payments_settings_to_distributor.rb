class AddPaymentsSettingsToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :bank_deposit, :boolean
    add_column :distributors, :paypal, :boolean
    add_column :distributors, :bank_deposit_format, :string
  end
end
