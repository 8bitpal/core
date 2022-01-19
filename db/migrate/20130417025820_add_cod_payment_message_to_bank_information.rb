class AddCodPaymentMessageToBankInformation < ActiveRecord::Migration[7.0]
  def change
    add_column :bank_information, :cod_payment_message, :text
  end
end
