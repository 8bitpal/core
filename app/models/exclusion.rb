class Exclusion < ActiveRecord::Base
  belongs_to :order
  belongs_to :line_item

  has_one :customer, through: :order

  validates_uniqueness_of :line_item_id, scope: :order_id

  scope :active, -> { joins(:order).where("orders.active = ?", true) }

  delegate :name, to: :line_item

  def self.change_line_items!(old_line_item, new_line_item)
    old_line_item.exclusions.each do |e|
      e.update_attribute(:line_item_id, new_line_item.id)
      e.save
    end
  end
end
