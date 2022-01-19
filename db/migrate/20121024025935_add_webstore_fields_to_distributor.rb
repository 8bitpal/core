class AddWebstoreFieldsToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :company_team_image, :string
    add_column :distributors, :about, :text
    add_column :distributors, :details, :text
    add_column :distributors, :facebook_url, :string
  end
end
