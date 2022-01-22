class UpdateNewColumnsToHaveDefaults < ActiveRecord::Migration[7.0]
  def up
    Box.update_all({ extras_limit: 0 })
    Package.update_all({ archived_extras: [].to_yaml })
    change_column :boxes, :extras_limit, :integer, default: 0
  end

  def down
  end
end
