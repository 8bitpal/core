class AddPaymentTypeToOmniImporter < ActiveRecord::Migration[7.0]
  def change
    add_column :omni_importers, :payment_type, :string
    remove_column :omni_importers, :global
  end
end
