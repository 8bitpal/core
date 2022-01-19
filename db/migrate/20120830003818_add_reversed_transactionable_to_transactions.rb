class AddReversedTransactionableToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :reverse_transactionable_id, :integer
    add_column :transactions, :reverse_transactionable_type, :string
  end
end
