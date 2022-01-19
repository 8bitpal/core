class AddOmniImporterToImportTransactionList < ActiveRecord::Migration[7.0]
  def change
    add_column :import_transaction_lists, :omni_importer_id, :integer
  end
end
