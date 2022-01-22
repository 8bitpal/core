class CreateBankInformation < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_information do |t|
      t.references :distributor
      t.string :name
      t.string :account_name
      t.string :account_number
      t.text :customer_message

      t.timestamps
    end
  end
end
