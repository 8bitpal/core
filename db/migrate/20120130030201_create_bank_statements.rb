class CreateBankStatements < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_statements do |t|
      t.references :distributor
      t.string :statement_file

      t.timestamps
    end
  end
end
