class Account < ActiveRecord::Base
  belongs_to :customer

  has_one :distributor, through: :customer

  has_many :orders,          dependent: :destroy
  has_many :payments,        dependent: :destroy
  has_many :deductions,      dependent: :destroy
  has_many :active_orders,   class_name: 'Order', conditions: { active: true }
  has_many :transactions,    dependent: :destroy, autosave: true
  has_many :deliveries,      through: :orders
  has_many :invoices

  has_one :delivery_service, through: :customer
  has_one :address,          through: :customer

  monetize :balance_cents

  attr_accessible :customer, :tag_list, :default_payment_method

  before_validation :default_balance_and_currency

  validates_presence_of :customer, :balance, :currency
  validate :validates_default_payment_method

  delegate :name, to: :customer

  # A way to double check that the transactions and the balance have not gone out of sync.
  # THIS SHOULD NEVER HAPPEN! If it does fix the root cause don't make this write a new balance.
  # Likely somewhere a transaction is being created manually.
  # FIXME
  def calculate_balance(offset_size = 0)
    CrazyMoney.new(transactions.offset(offset_size).sum(&:amount))
  end

  def balance_cents=(value)
    raise(ArgumentError, "The balance can not be updated this way. Please use one of the model balance methods that create transactions.")
  end

  def balance=(value)
    raise(ArgumentError, "The balance can not be updated this way. Please use one of the model balance methods that create transactions.")
  end

  def add_to_balance(amount, options = {})
    create_transaction(amount, options)
  end

  def subtract_from_balance(amount, options = {})
    create_transaction(amount * -1, options)
  end

  def create_transaction(amount, options = {})
    raise "amount should not be a float as floats are inaccurate for currency" if amount.is_a? Float

    amount = CrazyMoney.new(amount)
    transactionable = (options[:transactionable] ? options[:transactionable] : self)
    description = (options[:description] ? options[:description] : I18n.t('models.account.manual_transaction'))
    transaction_options = { amount: amount, transactionable: transactionable, description: description }
    transaction_options.merge!(display_time: options[:display_time]) if options[:display_time]
    transaction = nil

    with_lock do
      Account.update_counters(self.id, balance_cents: amount.cents)
      transaction = transactions.create(transaction_options)
    end

    # force update `balance_cents` attribute changed via `Account.update_counters` above
    self.reload
    update_halted_status

    transaction
  end

  def change_balance_to!(amount, opts = {})
    raise "amount should not be a float as floats are unprecise for currency" if amount.is_a? Float

    amount = CrazyMoney.new(amount)
    with_lock do
      create_transaction(amount - balance, opts)
    end
  end

  #all accounts that need invoicing
  def self.need_invoicing
    accounts = []
    Account.all.find_each { |account| accounts << account if account.needs_invoicing? }
    accounts
  end

  #future occurrences for all orders on account
  def all_occurrences(end_date)
    occurrences = []

    orders.each do |order|
      order.future_deliveries(end_date).each do |occurrence|
        occurrences << occurrence
      end
    end

    occurrences.sort { |a,b| a[:date] <=> b[:date] }
  end

  # This holds the core logic for when an invoice should be raised
  def next_invoice_date
    total = balance
    invoice_date = nil
    occurrences = all_occurrences(4.weeks.from_now)

    if total < distributor.invoice_threshold
      # No matter what if the account is below the threshold send out an invoice
      return Date.current
    else
      occurrences.each do |occurrence|
        total -= amount_with_bucky_fee(occurrence[:price])

        if total < distributor.invoice_threshold
          invoice_date = occurrence[:date] - 12.days
          break
        end
      end
    end

    if invoice_date
      invoice_date = Date.current if invoice_date < Date.current

      # After talking to @joshuavial the + 2.days is because of the buisness requirement:
      # it never send an invoice before 2 days after the first delivery
      if deliveries.size > 0 && deliveries.ordered.first.date.present? && deliveries.ordered.first.date >= invoice_date
        invoice_date = deliveries.ordered.first.date + 2.days
      elsif deliveries.size == 0 && occurrences.first && occurrences.first[:date] >= invoice_date
        invoice_date = occurrences.first[:date] + 2.days
      end

      invoice_date = Date.current if invoice_date < Date.current
    end

    invoice_date
  end

  # Used internally for calculating invoice totals
  # if distributor charges bucky fee in addition to box price return price + bucky fee
  def self.amount_with_bucky_fee(amount, distributor)
    bucky_fee_multiple = distributor.separate_bucky_fee ? (1 + distributor.bucky_box_percentage) : 1
    amount * bucky_fee_multiple
  end

  def amount_with_bucky_fee(amount)
    Account.amount_with_bucky_fee(amount, distributor)
  end

  def needs_invoicing?
    next_invoice_date.present? && next_invoice_date <= Date.current && invoices.outstanding.count == 0
  end

  def create_invoice
    Invoice.create_for_account(self) if needs_invoicing?
  end

  def update_halted_status
    customer.update_halted_status!(nil, Customer::EmailRule.all)
  end

  def balance_at(date)
    BigDecimal.new(transactions.where(['display_time <= ?', date]).sum(&:amount_cents)) / BigDecimal.new(100)
  end

private

  def default_balance_and_currency
    write_attribute(:balance_cents, 0) if balance_cents.blank?
    write_attribute(:currency, customer.currency) if currency.blank?
  end

  def validates_default_payment_method
    return if default_payment_method.nil? ||
      default_payment_method == PaymentOption::PAID ||
      default_payment_method.in?(Distributor.all_payment_options.keys.map(&:to_s))

    errors.add(:default_payment_method, "Unknown payment method #{default_payment_method.inspect}")
  end
end
