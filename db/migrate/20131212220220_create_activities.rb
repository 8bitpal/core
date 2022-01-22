class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.references :customer, null: false
      t.text :action, null: false

      t.timestamps
    end
  end
end
