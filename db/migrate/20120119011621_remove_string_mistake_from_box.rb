class RemoveStringMistakeFromBox < ActiveRecord::Migration[7.0]
  def up
    remove_column :boxes, :string
  end

  def down
    add_column :boxes, :string, :string
  end
end
