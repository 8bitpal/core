class AddHiddenBooleanToBoxes < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :hidden, :boolean, default: false, null: false
  end
end
