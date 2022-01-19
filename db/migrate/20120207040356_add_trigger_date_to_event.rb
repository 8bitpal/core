class AddTriggerDateToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :trigger_on, :datetime
  end
end
