class CreateImportTransactionLists < ActiveRecord::Migration[7.0]
  def change
    create_table :import_transaction_lists do |t|
      t.integer :distributor_id
      t.boolean :draft
      t.integer :account_type
      t.integer :source_type
      t.string :csv_file

      t.timestamps
    end
  end
end
