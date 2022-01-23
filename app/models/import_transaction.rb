class ImportTransaction < ActiveRecord::Base
  belongs_to :import_transaction_list
  has_one :distributor, through: :import_transaction_list
  belongs_to :customer
  belongs_to :payment

  monetize :amount_cents

  serialize :raw_data

  MATCH_MATCHED = "matched".freeze
  MATCH_UNABLE_TO_MATCH = "unable_to_match".freeze
  MATCH_DUPLICATE = "don't import (duplicate detected)".freeze
  MATCH_NOT_A_CUSTOMER = "not_a_customer / match_later".freeze
  MATCH_TYPES = {
    MATCH_MATCHED => 0,
    MATCH_NOT_A_CUSTOMER => 1,
    MATCH_DUPLICATE => 2,
    MATCH_UNABLE_TO_MATCH => 3,
  }.freeze
  MATCH_SELECT = (MATCH_TYPES.keys - [MATCH_MATCHED]).map do |symbol|
    [symbol.humanize, symbol]
  end.freeze

  scope :ordered,   -> { order("transaction_date DESC, created_at DESC") }
  scope :draft,     -> { where(['import_transactions.draft = ?', true]) }
  scope :processed, -> { where(['import_transactions.draft = ?', false]) }

  scope :matched,     -> { where(["match = ?", MATCH_TYPES[MATCH_MATCHED]]) }
  scope :not_matched, -> { where(["match != ?", MATCH_TYPES[MATCH_MATCHED]]) }

  scope :unable_to_match,     -> { where(["match = ?", MATCH_TYPES[MATCH_UNABLE_TO_MATCH]]) }
  scope :not_unable_to_match, -> { where(["match != ?", MATCH_TYPES[MATCH_UNABLE_TO_MATCH]]) }

  scope :duplicate,     -> { where(["match = ?", MATCH_TYPES[MATCH_DUPLICATE]]) }
  scope :not_duplicate, -> { where(["match != ?", MATCH_TYPES[MATCH_DUPLICATE]]) }

  scope :not_a_customer,     -> { where(["match = ?", MATCH_TYPES[MATCH_NOT_A_CUSTOMER]]) }
  scope :not_not_a_customer, -> { where(["match != ?", MATCH_TYPES[MATCH_NOT_A_CUSTOMER]]) }

  scope :removed,     -> { where(removed: true) }
  scope :not_removed, -> { where(removed: false) }

  validate :customer_belongs_to_distributor

  before_save :update_account, if: :changed?

  delegate :account, to: :import_transaction_list
  delegate :currency, to: :distributor

  def self.new_from_row(row, import_transaction_list, distributor)
    match_result = row.single_customer_match(distributor)

    ImportTransaction.new(
      customer: match_result.customer,
      transaction_date: row.date,
      amount_cents: row.amount.cents,
      removed: false,
      description: row.description,
      confidence: match_result.confidence,
      import_transaction_list: import_transaction_list,
      match: match_type(match_result),
      draft: true,
      raw_data: row.raw_data
    )
  end

  def self.match_type(match_result)
    case match_result.type
    when :match
      MATCH_MATCHED
    when :duplicate
      MATCH_DUPLICATE
    when :not_a_customer
      MATCH_NOT_A_CUSTOMER
    when :unable_to_match
      MATCH_UNABLE_TO_MATCH
    else
      raise "MatchResult didn't have a valid type - #{match_result.inspect}"
    end
  end

  def row
    Bucky::TransactionImports::Row.new(transaction_date, description, amount_cents)
  end

  def possible_customers(customer_badges)
    result = customer.present? ? [[customer.badge, customer.id]] : []
    result += draft? ? MATCH_SELECT : [[MATCH_NOT_A_CUSTOMER.humanize, MATCH_NOT_A_CUSTOMER]]
    result += customer_badges.reject { |_, id| id == customer_id }
    result
  end

  def confidence
    self[:confidence] || 0
  end

  def match=(m)
    raise "#{m} was not in #{MATCH_TYPES}" unless MATCH_TYPES.include?(m)
    self[:match] = MATCH_TYPES[m]
  end

  def match
    MATCH_TYPES.key(self[:match])
  end

  def match_id
    customer_id || match
  end

  def matched?
    match == MATCH_MATCHED && customer.present?
  end

  def duplicate?
    match == MATCH_DUPLICATE
  end

  def customer_was
    distributor.customers.find_by_id(customer_id_was)
  end

  def payment_created?
    payment.present?
  end

  def raw_data
    self[:raw_data] || {}
  end

  def remove!
    return true if removed?

    ImportTransaction.transaction do
      payment.reverse_payment! if payment.present?
      self.removed = true
      save!
    end
  end

  def self.process_attributes(transaction_attributes)
    if ImportTransaction::MATCH_TYPES.include?(transaction_attributes['customer_id'])
      transaction_attributes['match'] = transaction_attributes['customer_id']
      transaction_attributes['customer_id'] = nil
    else
      transaction_attributes['match'] = ImportTransaction::MATCH_MATCHED
    end

    transaction_attributes
  end

  def payment_type
    if matched?
      if import_transaction_list.has_payment_type?
        import_transaction_list.payment_type
      else
        case account
        when 'Paypal'
          'PayPal'
        else
          'Bank Deposit'
        end
      end
    else
      ''
    end
  end

  def confidence_high?
    confidence >= 0.75
  end

private

  def distributor_customer_ids
    distributor.customer_ids
  end

  def update_account
    # Undo payment to the previous matched customer if they are no longer the match
    if customer_id_changed? && customer_was.present? && payment_created?
      self.payment.reverse_payment!
      self.payment = nil
    end
    # Create new payments if a new customer has been assigned
    if !draft && matched? && !payment_created? && customer.present?
      self.create_payment(
        distributor: distributor,
        account: customer.account,
        amount: amount,
        kind: 'unspecified',
        source: 'import',
        description: payment_description(payment_type, amount),
        display_time: transaction_date.to_time_in_current_zone,
        payable: self
      )
    end
  end

  def customer_belongs_to_distributor
    errors.add(:base, "Customer isn't known to this distributor") unless customer_id.blank? || distributor_customer_ids.include?(customer_id)
  end

  def payment_description(payment_type, amount)
    if amount.positive?
      "Payment made by #{payment_type}"
    else
      "Refund made by #{payment_type}"
    end
  end
end
