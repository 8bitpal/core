class AddFileFormatToImportTransactionList < ActiveRecord::Migration[7.0]
  def change
    add_column :import_transaction_lists, :file_format, :string
  end
end
