class AddCollectDeliveryNoteToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :collect_delivery_note, :boolean, default: true, null: false
  end
end
