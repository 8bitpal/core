class Distributor::Settings::Payments::BankDeposit < Distributor::Settings::Payments::Base
  delegate :name,
    :account_name,
    :account_number,
    :account_name,
    :customer_message,
    to: :bank_information

  def initialize(args)
    super
    @bank_deposit = args[:bank_deposit]

    # merge bank number parts into a single string
    @bank_deposit[:account_number] = @bank_deposit[:account_number].join if @bank_deposit
  end

  def save
    @bank_information.update_attributes(@bank_deposit)
  end
end
