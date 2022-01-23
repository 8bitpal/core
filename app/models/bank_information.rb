class BankInformation < ActiveRecord::Base
  belongs_to :distributor, touch: true

  validates_presence_of :distributor
  validates_presence_of :name, :account_name, :account_number, if: -> { distributor.payment_bank_deposit }

  delegate :country, to: :distributor
end
