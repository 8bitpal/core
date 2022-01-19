class AddCompletedWizardBooleanToDistributor < ActiveRecord::Migration[7.0]
  def change
    add_column :distributors, :completed_wizard, :boolean, default: false, null: false
  end
end
