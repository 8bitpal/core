class CreateOmniImporters < ActiveRecord::Migration[7.0]
  def change
    create_table :omni_importers do |t|
      t.integer :country_id
      t.boolean :global
      t.text :rules
      t.string :import_transaction_list
      t.string :name

      t.timestamps
    end
  end
end
