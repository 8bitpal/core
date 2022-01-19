class RemoveBankStatements < ActiveRecord::Migration[7.0]
  def change
    drop_table :bank_statements
  end
end
