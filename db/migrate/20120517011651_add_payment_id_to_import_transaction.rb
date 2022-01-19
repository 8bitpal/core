class AddPaymentIdToImportTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :import_transactions, :payment_id, :integer
  end
end
