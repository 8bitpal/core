class RenameInvoiceThresholdCurrencyInDistributors < ActiveRecord::Migration[7.0]
  def change
    rename_column :distributors, :currency, :invoice_threshold_currency
  end
end
