class AddFeeToRoute < ActiveRecord::Migration[7.0]
  def change
    add_column :routes, :fee_cents, :integer, default: 0
    add_column :routes, :currency, :string
  end
end
