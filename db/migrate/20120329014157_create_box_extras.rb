class CreateBoxExtras < ActiveRecord::Migration[7.0]
  def change
    create_table :box_extras do |t|
      t.integer :box_id
      t.integer :extra_id

      t.timestamps
    end
  end
end
