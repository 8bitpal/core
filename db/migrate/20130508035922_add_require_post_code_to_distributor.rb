class AddRequirePostCodeToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :require_post_code, :boolean, null: false, default: false
  end
end
