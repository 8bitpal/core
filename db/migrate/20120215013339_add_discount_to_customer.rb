class AddDiscountToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :discount, :decimal, default: 0, null: false
  end
end
