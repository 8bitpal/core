class AddNotesToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :notes, :text
  end
end
