class AddCompanyLogoToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :company_logo, :string
  end
end
