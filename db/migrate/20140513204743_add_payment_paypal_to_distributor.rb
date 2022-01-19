class AddPaymentPaypalToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :payment_paypal, :boolean, null: false, default: false
  end
end
