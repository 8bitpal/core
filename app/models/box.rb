class Box < ActiveRecord::Base
  HUMANIZED_ATTRIBUTES = {
    price_cents: "Price",
  }.freeze

  EXTRAS_UNLIMITED = -1
  EXTRAS_DISABLED = 0

  # [["disable extras", 0], ["allow any number of extra items", -1],
  # ["allow 1 extra items", 1], ["allow 2 extra items", 2], ... ["allow n extra items, n]]
  SPECIAL_EXTRA_OPTIONS = ['disable extras', 'allow any number of extra items'].zip([EXTRAS_DISABLED, EXTRAS_UNLIMITED])
  COUNT_EXTRA_OPTIONS = 1.upto(10).map { |i| "allow #{i} extra items" }.zip(1.upto(10).to_a)
  EXTRA_OPTIONS = (SPECIAL_EXTRA_OPTIONS + COUNT_EXTRA_OPTIONS)

  belongs_to :distributor

  has_many :orders
  has_many :box_extras
  has_many :extras, through: :box_extras

  mount_uploader :box_image, BoxImageUploader

  # Setup accessible (or protected) attributes for your model
  attr_accessor :distributor, :name, :description, :likes, :dislikes, :price, :available_single, :available_weekly,
    :available_fourtnightly, :box_image, :box_image_cache, :remove_box_image, :extras_limit, :extra_ids, :hidden, :visible, :exclusions_limit, :substitutions_limit, :extras

  validates_presence_of :distributor, :name, :description, :price
  validates :extras_limit, numericality: { greater_than: -2 }
  validates :name, length: { maximum: 80 }
  validates :price_cents, numericality: { greater_than_or_equal_to: 0, less_than: 1E8 }

  monetize :price_cents

  default_value_for :extras_limit, EXTRAS_DISABLED
  default_value_for :substitutions_limit, 0
  default_value_for :exclusions_limit, 0

  default_scope { order(:name) }
  scope :not_hidden, -> { where(hidden: false) }

  def exclusions?; dislikes?; end

  def substitutions?; likes?; end

  def visible; !hidden; end

  def visible=(value)
    self[:hidden] = !value.to_bool
  end

  def extras_allowed?
    !extras_not_allowed?
  end

  def extras_unlimited?
    extras_limit == EXTRAS_UNLIMITED
  end

  def extras_not_allowed?
    extras_limit.blank? || extras_limit == EXTRAS_DISABLED
  end
  alias_method :extras_disabled?, :extras_not_allowed?

  def extra_option
    if extras_unlimited?
      "any number of extras"
    elsif extras_disabled?
      "disabled"
    elsif extras_limit == 1
      "1 extra allowed"
    else
      "#{extras_limit} extras allowed"
    end
  end

  def big_thumb_url
    box_image.thumb.url
  end

  def webstore_image_url
    box_image.webstore.url
  end

  def customisable?
    dislikes? || extras_allowed?
  end

  def substitutions_limit
    self[:substitutions_limit] || 0
  end

  def substitutions_unlimited?
    substitutions_limit.zero?
  end

  def exclusions_limit
    self[:exclusions_limit] || 0
  end

  def exclusions_unlimited?
    exclusions_limit.zero?
  end

  def has_all_extras?(exclude = [])
    exclude = [exclude] unless exclude.is_a?(Array)
    (distributor.extras - exclude).sort == extras.sort
  end

  # Used to select which drop down value is selected
  # on extras form
  def all_extras?
    if new_record? || extras_disabled? # By default show 'from the entire extras catalog'
      true
    elsif distributor.present?
      has_all_extras?
    else
      false
    end
  end
  alias_method :all_extras, :all_extras? # I prefer to have '?' on the end of methods but simple_form won't take it as an attribute

  def limits_data
    { likes: substitutions_limit, dislikes: exclusions_limit }
  end

  def available_extras
    extras_allowed? ? extras.not_hidden.alphabetically : self.class.none
  end

  def cache_key(embed = Set.new)
    keys = [super()]

    keys += [
      available_extras.map(&:id).hash,
      available_extras.map(&:updated_at).hash,
    ] if embed.include?("extras")

    keys += [
      distributor.line_items.map(&:id).hash,
      distributor.line_items.map(&:updated_at).hash,
    ] if embed.include?("box_items")

    keys.join("-").freeze
  end

private

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
