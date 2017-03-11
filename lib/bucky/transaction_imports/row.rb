module Bucky::TransactionImports
  class Row
    include ActiveModel::Validations

    attr_accessor :date_string, :amount_string, :description, :index, :raw_data, :parser, :bank_name

    validate :row_is_valid

    def initialize(date_string, description, amount_string, index = nil, raw_data = nil, parser = nil, bank_name = nil)
      self.date_string = date_string
      self.description = description || ""
      self.amount_string = amount_string
      self.index = index
      self.parser = parser
      self.raw_data = raw_data
      self.bank_name = bank_name
    end

    def date
      Date.parse(@date_string)
    end

    def amount
      CrazyMoney.new(@amount_string)
    end

    MATCH_STRATEGY = [[:email_match, 1.0],
                      [:number_match, 0.8],
                      [:name_match, 0.8]].freeze

    # Returns a number 0.0 -> 1.0 indicating how confident we
    # are that this payment comes from customer
    # 0.0 no confidence
    # 1.0 total confidence
    def match_confidence(customer)
      current_confidence = 0.0
      MATCH_STRATEGY.each do |method, confidence|
        current_confidence += self.send(method, customer) * confidence
        break if current_confidence > 0.8
      end
      [1.0, current_confidence].min
    end

    def previous_match(distributor)
      distributor.find_previous_match(description)
    end

    def email_match(customer)
      if customer.email.present? && description.match(Regexp.escape(customer.email))
        1.0
      else
        0.0
      end
    end

    def number_match(customer)
      number_reference.collect do |number_reference|
        if customer.formated_number == number_reference # Match the full 0014 to 0014
          1
        elsif customer.formated_number == ("%04d" % number_reference.to_i) # Match partial 14 -> 0014
          0.3
        else
          0
        end
      end.sort.last || 0 # Out of all the numbers in the description, pick the best match
    end

    def name_match(customer)
      regex = Regexp.new(Regexp.escape(customer.name).gsub(/\W+/, ".{0,3}"), true) # 0,3 means that it allows 0 -> 3 chars between the first and last name, be it a space or a dot or some other mistake
      if description.match(regex)
        # Match first and last name, ignoring case
        1
      elsif customer.has_first_and_last_name? && customer.last_name.size > 1 # This fixes a bug where someone only has a first name (Say Phoenix) and the regex created is P.* which matches "payment" which isn't good!
        # Match first inital and last name
        regex = Regexp.new("#{Regexp.escape(customer.first_name.first)} #{Regexp.escape(customer.last_name)}".gsub(/\W+/, ".{0,3}"), true)
        description.match(regex).present? ? 0.9 : 0
      else
        0
      end
    end

    NUMBER_REFERENCE_REGEX = /(\d+)/
    def number_reference
      @possible_references ||= description.scan(NUMBER_REFERENCE_REGEX).to_a.flatten
    end

    def customers_match_with_confidence(customers)
      if not_customer? # Don't search for customers that match if we know its not going to match
        []
      else
        customers.collect do |customer|
          MatchResult.customer_match(customer, match_confidence(customer))
        end.sort.select do |result|
          result.confidence >= 0.48 # Threshold for selecting a match
        end.reverse
      end
    end

    def single_customer_match(distributor)
      if duplicate?(distributor)
        MatchResult.duplicate_match(1.0)
      elsif not_customer?
        MatchResult.not_a_customer(1.0)
      elsif (@prev_match = previous_match(distributor)).present?
        MatchResult.customer_match(@prev_match.customer, 1.0)
      else
        matches = customers_match_with_confidence(distributor.customers)
        match = matches.first
        match.present? ? match : MatchResult.unable_to_match
      end
    end

    def duplicate?(distributor)
      duplicates(distributor).count.nonzero?
    end

    def duplicates(distributor)
      distributor.find_duplicate_import_transactions(date, description, amount)
    end

    def credit?
      amount.positive?
    end

    def debit?
      !credit?
    end

    def not_customer?
      debit?
    end

    def to_s
      "#{date} #{description} #{amount}"
    end

    def row_is_valid
      unless date_valid? && amount_valid?
        invalid = []
        invalid << "invalid date: #{date_string.inspect}" unless date_valid?
        invalid << "invalid amount: #{amount_string.inspect}" unless amount_valid?

        errors.add(:base, "Transaction line #{index.succ} looks suspect (#{invalid.to_sentence}).")
      end
    end

    def date_valid?
      date = Date.parse(date_string) # Will throw ArgumentError: invalid date
      date > 1.year.ago.to_date && date <= 5.days.from_now.to_date
    rescue ArgumentError
      false
    end

    AMOUNT_REGEX = /\A[+-]?\d*\.?\d+\Z/
    def amount_valid?
      amount_string.present? && amount_string.match(AMOUNT_REGEX).present?
    end
  end

  class MatchResult
    attr_accessor :customer, :confidence, :type

    def initialize(customer, confidence, type)
      self.customer = customer
      self.confidence = confidence
      self.type = type
    end

    def self.customer_match(customer, confidence)
      MatchResult.new(customer, confidence, :match)
    end

    def self.duplicate_match(confidence)
      MatchResult.new(nil, confidence, :duplicate)
    end

    def self.not_a_customer(confidence)
      MatchResult.new(nil, confidence, :not_a_customer)
    end

    def self.unable_to_match
      MatchResult.new(nil, 0.0, :unable_to_match)
    end

    def <=>(other)
      if self.confidence == other.confidence
        self.customer <=> other.customer
      else
        self.confidence <=> other.confidence
      end
    end
  end
end
