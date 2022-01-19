class UpdateDistributorCurrencyToUpcase < ActiveRecord::Migration[7.0]
  def up
    Distributor.reset_column_information
    Distributor.transaction do
      Distributor.all.each do |d|
        d.update_column(:currency, d.currency.upcase)
      end
    end
  end

  def down
  end
end
