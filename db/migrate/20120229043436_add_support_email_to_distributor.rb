class AddSupportEmailToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :support_email, :string
  end
end
