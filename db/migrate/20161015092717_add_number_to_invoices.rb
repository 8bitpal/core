class AddNumberToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :distributor_invoices, :number, :string, null: true
  end
end
