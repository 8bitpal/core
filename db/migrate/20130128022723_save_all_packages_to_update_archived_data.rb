class SaveAllPackagesToUpdateArchivedData < ActiveRecord::Migration[7.0]
  def up
    Package.unpacked.all.map(&:save)
  end

  def down
  end
end
