class RenameRequirePostCodeForDistributor < ActiveRecord::Migration[7.0]
  def up
   rename_column :distributors, :require_post_code, :require_postcode
  end

  def down
   rename_column :distributors, :require_postcode, :require_post_code
  end
end
