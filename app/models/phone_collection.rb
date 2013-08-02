# Class to store multiple phone numbers
# Each number is associated with a type (mobile, home, work)
class PhoneCollection
  TYPES = %w(mobile home work).inject({}) do |hash, type|
    hash.merge!(type => "#{type}_phone")
  end.freeze

  def self.attributes
    TYPES.values
  end

  def self.types_as_options
    TYPES.each_key.map { |type| type_option(type) }
  end

  def initialize address
    @address = address
  end

  def all
    TYPES.each_value.map do |attribute|
      phone = @address.send(attribute)
      "#{attribute.humanize}: #{phone}" unless phone.blank?
    end.compact
  end

  def default_number
    @address.send(default[:attribute])
  end

  def default_type
    default[:type]
  end

private

  def self.type_option(type)
    [ type.capitalize, type ]
  end

  def default
    default = TYPES.first
    { type: default.first, attribute: default.last }
  end
end

