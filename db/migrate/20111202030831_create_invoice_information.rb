class CreateInvoiceInformation < ActiveRecord::Migration[7.0]
  def change
    create_table :invoice_information do |t|
      t.references :distributor
      t.string :gst_number
      t.string :billing_address_1
      t.string :billing_address_2
      t.string :billing_suburb
      t.string :billing_city
      t.string :billing_postcode

      t.timestamps
    end
  end
end
