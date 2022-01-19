class AddLocaleToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :locale, :string, null: false, default: :en
  end
end
