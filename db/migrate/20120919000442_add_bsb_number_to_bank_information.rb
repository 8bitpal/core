class AddBsbNumberToBankInformation < ActiveRecord::Migration[7.0]
  def change
    add_column :bank_information, :bsb_number, :string
  end
end
