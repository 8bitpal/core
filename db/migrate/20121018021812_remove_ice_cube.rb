class RemoveIceCube < ActiveRecord::Migration[7.0]
  def change
    [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].each do |day|
      remove_column :routes, day
    end

    remove_column :orders, :schedule
    remove_column :orders, :frequency
  end
end
