class AddNotesToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :notes, :text
  end
end
