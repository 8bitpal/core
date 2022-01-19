class LengthenPackageData < ActiveRecord::Migration[7.0]
  def up
    change_table :packages do |t|
      t.change :archived_exclusions, :text
      t.change :archived_substitutions, :text
    end
  end

  def down
    change_table :packages do |t|
      t.change :archived_exclusions, :string
      t.change :archived_substitutions, :string
    end
  end
end
