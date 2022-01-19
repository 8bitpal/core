class AddStatusToImportTransactionList < ActiveRecord::Migration[7.0]
  def change
    add_column :import_transaction_lists, :status, :string
  end
end
