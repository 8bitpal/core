class AddStatementIdToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :statement_id, :integer
  end
end
