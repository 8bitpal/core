class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.references :distributor
      t.string :name

      t.timestamps
    end
    add_index :line_items, :distributor_id
  end
end
