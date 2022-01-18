class CustomerCheckout < ActiveRecord::Base
  attr_accessor :customer, :distributor_id

  belongs_to :distributor
  belongs_to :customer

  def self.track(customer)
    CustomerCheckout.create!(customer: customer, distributor_id: customer.distributor_id)
  end
end
