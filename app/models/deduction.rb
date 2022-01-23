class Deduction < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :account, autosave: true
  belongs_to :deductable, polymorphic: true
  belongs_to :tx, class_name: "Transaction", foreign_key: "transaction_id"
  belongs_to :reversal_transaction, class_name: "Transaction"

  has_one :customer, through: :account

  has_many :transactions, as: :transactionable
  has_many :reversal_transactions, as: :reverse_transactionable, class_name: "Transaction"

  monetize :amount_cents

  KINDS = %w(delivery unspecified).freeze
  SOURCES = %w(manual auto).freeze # delivery uses both manual and auto

  validates_presence_of :distributor_id, :account_id, :amount, :kind, :description, :deductable_id, :deductable_type
  validates_inclusion_of :kind, in: KINDS, message: "%{value} is not a valid kind of payment"
  validates_inclusion_of :source, in: SOURCES, message: "%{value} is not a valid source of payment"
  validates_numericality_of :amount_cents, greater_than_or_equal_to: 0, only_integer: true

  after_create :make_deduction!

  scope :unspecified, -> { where(kind: 'unspecified') }
  scope :manual,      -> { where(source: 'manual') }
  scope :reversed,    -> { where(reversed: true) }

  def reverse_deduction!
    raise "This deduction has already been reversed." if self.reversal_transaction.present?

    self.reversed = true
    self.reversed_at = Time.current

    options = { description: "[REVERSED] " + self.description, display_time: self.display_time }

    Deduction.transaction do
      self.reversal_transaction = self.account.add_to_balance(tx.amount.opposite, options)
      self.reversal_transactions << reversal_transaction

      if bucky_fee
        self.reversal_transactions << self.account.add_to_balance(bucky_fee.amount.opposite, { description: "[REVERSED] Bucky Box Fee", display_time: self.display_time })
      end

      self.save
    end

    self.reversal_transaction
  end

  def manual?
    source == 'manual'
  end

  def bucky_fee
    transactions.find_by(['transactions.id != ?', tx.id])
  end

  def reversal_fee
    reversal_transactions.find_by(['transactions.id != ?', reversal_transaction.id])
  end

private

  def make_deduction!
    raise "This deduction has already been applied!" if self.tx.present?

    Deduction.transaction do
      if distributor.separate_bucky_fee
        self.transactions << account.subtract_from_balance(
          distributor.consumer_delivery_fee,
          transactionable: self,
          description: "Bucky Box Transaction Fee",
          display_time: display_time
        )
      end
      self.tx = account.subtract_from_balance(
        amount,
        transactionable: self,
        description: description,
        display_time: display_time
      )

      self.save!
    end

    self.tx
  end
end
