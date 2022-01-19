class AddDefaultPaymentMethodToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :default_payment_method, :string
  end
end
