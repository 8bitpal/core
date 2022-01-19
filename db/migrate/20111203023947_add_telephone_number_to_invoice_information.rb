class AddTelephoneNumberToInvoiceInformation < ActiveRecord::Migration[7.0]
  def change
    add_column :invoice_information, :phone, :string
  end
end
