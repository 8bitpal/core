class RenameStatementIdForPayment < ActiveRecord::Migration[7.0]
  def up
    rename_column :payments, :statement_id, :bank_statement_id
  end

  def down
    rename_column :payments, :bank_statement_id, :statement_id
  end
end
