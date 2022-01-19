class AddApiKeyAndSecretToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :api_key, :string
    add_index :distributors, :api_key, unique: true
    add_column :distributors, :api_secret, :string
  end
end
