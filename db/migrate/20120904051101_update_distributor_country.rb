class UpdateDistributorCountry < ActiveRecord::Migration[7.0]
  def up
    Distributor.reset_column_information
    Distributor.transaction do
      [[20, 'NZ'], [7, 'NZ'], [19, 'Mexico'], [2, 'NZ'], [14, 'AU'], [15, "NZ"]].each do |id, c_code|
        distributor = Distributor.find_by_id(id)
        country = Country.find_by_name(c_code)
        if distributor && country
          distributor.update_column(:country_id, country.id)
        end
      end
    end
  end

  def down
  end
end
