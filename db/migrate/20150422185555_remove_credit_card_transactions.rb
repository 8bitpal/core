class RemoveCreditCardTransactions < ActiveRecord::Migration[7.0]
  def change
    drop_table :credit_card_transactions
  end
end
