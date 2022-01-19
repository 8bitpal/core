class AddPaymentMethodToWebstoreOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :webstore_orders, :payment_method, :string
  end
end
