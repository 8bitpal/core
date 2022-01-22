class CreateSubstitutions < ActiveRecord::Migration[7.0]
  def change
    create_table :substitutions do |t|
      t.references :order
      t.references :line_item

      t.timestamps
    end
  end
end
