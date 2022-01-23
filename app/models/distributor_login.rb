# Keeps track of distributor logins
class DistributorLogin < ActiveRecord::Base
  belongs_to :distributor

  def self.track(distributor)
    DistributorLogin.create!(distributor: distributor)
  end
end
