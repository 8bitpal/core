class Address < ActiveRecord::Base
  ADDRESS_ATTRIBUTES = %w(
    address_1
    address_2
    suburb
    city
    postcode
    delivery_note
  )

  belongs_to :customer, inverse_of: :address

  attr_accessible :customer, :address_1, :address_2, :suburb, :city, :postcode, :delivery_note
  attr_accessible(*PhoneCollection.attributes)
  attr_accessor :phone
  attr_writer :distributor

  before_validation :update_phone

  validates_presence_of :customer

  before_save :update_address_hash

  def self.address_attributes
    ADDRESS_ATTRIBUTES
  end

  def to_s(join_with = ', ', options = {})
    result = [address_1]
    result << address_2 unless address_2.blank?
    result << suburb unless suburb.blank?
    result << city unless city.blank?
    result << postcode unless postcode.blank?

    if options[:with_phone]
      result << phones.all.join(join_with)
    end

    result.join(join_with).html_safe
  end

  alias_method :join, :to_s

  def ==(address)
    address.is_a?(Address) && [:address_1, :address_2, :suburb, :city, :postcode].all?{ |a|
      send(a) == address.send(a)
    }
  end

  def address_hash
    self[:address_hash] || compute_address_hash
  end

  def compute_address_hash
    Digest::SHA1.hexdigest([:address_1, :address_2, :suburb, :city, :postcode].collect{|a| send(a).downcase.strip rescue ''}.join(''))
  end

  def update_address_hash
    self.address_hash = compute_address_hash
  end

  # Useful for address validation without a customer
  def distributor
    customer && customer.distributor || @distributor
  end

  def phones
    @phones ||= PhoneCollection.new(self)
  end

  def default_phone_number
    phones.default_number
  end

  def default_phone_type
    phones.default_type
  end

  def update_with_notify(params, customer)
    self.attributes = params

    return true unless changed? #nothing to save, nothing to notify

    if save
      customer.send_address_change_notification
      return true
    else
      return false
    end
  end

private

  # Handy helper to update a given number type (used in the web store)
  def update_phone
    return unless phone

    type, number = phone[:type], phone[:number]
    return unless type.present?

    self.send("#{type}_phone=", number)
  end
end
