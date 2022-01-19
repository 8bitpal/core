class AddCollectPhoneInWebstoreToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :collect_phone_in_webstore, :boolean
  end
end
