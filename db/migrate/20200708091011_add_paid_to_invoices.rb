class AddPaidToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :distributor_invoices, :paid, :bool, null: false, default: false
  end
end
