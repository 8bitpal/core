class AddPhoneToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :phone, :string
  end
end
