class AddRequireDeliveryNoteToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :require_delivery_note, :boolean, default: false, null: false
  end
end
