class Admin < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :email, :password, :password_confirmation, :remember_me
end
