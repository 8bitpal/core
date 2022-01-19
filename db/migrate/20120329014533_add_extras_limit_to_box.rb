class AddExtrasLimitToBox < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :extras_limit, :integer
  end
end
