class AddHiddenFlagToExtras < ActiveRecord::Migration[7.0]
  def change
    add_column :extras, :hidden, :boolean, default: false
  end
end
