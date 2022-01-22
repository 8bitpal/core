class ImportTransactionList < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :omni_importer
  has_many :import_transactions, autosave: true, validate: true, dependent: :destroy
  accepts_nested_attributes_for :import_transactions

  validates_presence_of :csv_file
  validate :csv_ready, on: :create

  mount_uploader :csv_file, ImportTransactionListUploader

  before_create :import_rows

  scope :ordered, -> { order("created_at DESC") }
  scope :draft, -> { where(['import_transaction_lists.draft = ?', true]) }
  scope :processed, -> { where(['import_transaction_lists.draft = ?', false]) }

  attr_accessor :csv_file, :import_transactions_attributes, :draft, :omni_importer_id
  delegate :payment_type, to: :omni_importer, allow_nil: true

  state_machine :status, initial: :pending do
    event :set_processing! do
      transition all - :processing => :processing
    end

    event :set_pending! do
      transition all => :pending
    end
  end

  def account
    omni_importer.name if omni_importer.present?
  end

  def has_failed?
    errors.present? || (csv_parser && csv_parser.rows.any?(&:invalid?))
  end

  def error_messages
    if csv_parser.present?
      csv_parser.rows.select(&:invalid?).map { |row| row.errors.values }
    elsif errors.present?
      errors.full_messages
    end
  end

  def has_payment_type?
    payment_type.present?
  end

  def import_rows
    csv_parser.rows.each do |row|
      import_transactions << ImportTransaction.new_from_row(row, self, distributor)
    end

    import_transactions
  end

  def csv_parser
    return @parser unless @parser.blank?
    return nil unless errors.blank? && csv_file.present?

    @parser = omni_importer.import(csv_file.current_path)
  end

  def file_format
    "omni_importer"
  end

  def process_import_transactions_attributes(import_transaction_list_attributes)
    # Expecting transactions_attributes to look like [1, {"id": 234, "customer_id":12 },
    #                                                 2, {"id": 65, "customer_id":1}....]
    transactions_attributes = import_transaction_list_attributes[:import_transactions_attributes]

    # Pull out the non customer_ids (duplicate, not_a_customer, etc..)
    transactions_attributes.each do |_id, transaction_attributes|
      ImportTransaction.process_attributes(transaction_attributes)
    end

    import_transaction_list_attributes
  end

  def process_attributes(attr)
    self.draft = false
    update_attributes(attr.merge(draft: false))
  end

  def processed?
    !draft?
  end

  def csv_valid?
    begin
      csv_parser.present? && csv_parser.respond_to?(:rows_are_valid?) && csv_parser.rows_are_valid?
    rescue StandardError => ex # Catch a totally crappy file
      logger.warn(ex.to_s)
      return false
    end

    if csv_parser.is_a?(OmniImporter)
      errors.blank? && csv_parser.present? && csv_parser.rows_are_valid?
    else
      errors.blank? && csv_parser.present? && csv_parser.valid?
    end
  end

  def can_process?
    with_lock do
      return false if processed? || processing?
      set_processing!
    end
    true
  end

  def processing_failed!
    set_pending!
  end

private

  def csv_ready
    unless csv_valid?
      errors.add(:base, "Seems to be a problem with that CSV file.")
    end
  end
end
