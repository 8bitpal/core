class AddExtrasOneOffToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :extras_one_off, :boolean, default: true
  end
end
