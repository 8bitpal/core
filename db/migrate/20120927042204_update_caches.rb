class UpdateCaches < ActiveRecord::Migration[7.0]
  def up
    # Now that ice cube is up to date, run the caches again
    Distributor.find_each(&:update_next_occurrence_caches)
  end

  def down
  end
end
