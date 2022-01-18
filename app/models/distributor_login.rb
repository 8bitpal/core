# Keeps track of distributor logins
class DistributorLogin < ActiveRecord::Base
  attr_accessor :distributor

  belongs_to :distributor

  def self.track(distributor)
    DistributorLogin.create!(distributor: distributor)
  end
end
