class RemoveInvoices < ActiveRecord::Migration[7.0]
  def change
    drop_table :invoices
    drop_table :invoice_information

    remove_column :distributors, :invoice_threshold_cents
  end
end
