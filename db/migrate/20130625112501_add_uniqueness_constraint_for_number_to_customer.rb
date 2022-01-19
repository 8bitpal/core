class AddUniquenessConstraintForNumberToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_index :customers, [:distributor_id, :number], unique: true
  end
end
