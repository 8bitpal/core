class AddRawDataToImportTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :import_transactions, :raw_data, :text
  end
end
