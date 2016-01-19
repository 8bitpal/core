require 'date'
require 'csv'
require_relative '../report'

class Report::TransactionHistory
  NAME_PREFIX = 'bucky-box-transaction-history-export'.freeze
  DATE_FORMAT = '%d/%b/%Y'.freeze

  def initialize(args = {})
    @distributor  = args[:distributor]
    @from         = Date.parse(args[:from])
    @to           = Date.parse(args[:to])
    @transactions = distributor.transactions_for_export(from, to)
  end

  def name
    "#{NAME_PREFIX}-#{Report.format_date(from)}-to-#{Report.format_date(to)}"
  end

  def data
    CSV.generate do |csv|
      csv << csv_header
      transactions.each { |transaction| csv << csv_row(transaction) }
    end
  end

private

  attr_reader :distributor
  attr_reader :from
  attr_reader :to
  attr_reader :transactions

  def csv_header
    [
      "transaction date",
      "transaction processed date",
      "transaction amount",
      "transaction type",
      "transaction description",
      "customer number",
      "customer first name",
      "customer last name",
      "customer email",
      "customer discount",
      "customer labels",
    ]
  end

  def csv_row(transaction)
    add_transaction_data(transaction) + add_customer_data(transaction)
  end

  def add_transaction_data(transaction)
    [
      transaction.display_time.strftime(DATE_FORMAT),
      transaction.created_at.strftime(DATE_FORMAT),
      transaction.amount,
      transaction.transactionable_type,
      transaction.description,
    ]
  end

  def add_customer_data(transaction)
    customer = transaction_customer(transaction)

    [
      customer.number,
      customer.first_name,
      customer.last_name,
      customer.email,
      customer.discount,
      customer.labels,
    ]
  end

  def transaction_customer(transaction)
    transaction.customer
  end
end
