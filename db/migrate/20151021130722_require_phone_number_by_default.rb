class RequirePhoneNumberByDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :distributors, :collect_phone, :boolean, default: true, null: false
    change_column :distributors, :require_phone, :boolean, default: true, null: false
  end
end
