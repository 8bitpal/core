class CustomerCheckout < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :customer

  def self.track(customer)
    CustomerCheckout.create!(customer: customer, distributor_id: customer.distributor_id)
  end
end
