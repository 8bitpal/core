class SetBuckyFeeToFalseByDefault < ActiveRecord::Migration[7.0]
  def up
    change_column :distributors, :separate_bucky_fee, :boolean, default: :false
  end

  def down
    change_column :distributors, :separate_bucky_fee, :boolean, default: :true
  end
end
