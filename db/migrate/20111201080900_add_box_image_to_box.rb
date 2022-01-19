class AddBoxImageToBox < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :box_image, :string
  end
end
