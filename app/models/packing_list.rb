class PackingList < ActiveRecord::Base
  belongs_to :distributor

  has_many :packages, dependent: :destroy, order: :position

  attr_accessor :distributor, :distributor_id, :date

  validates_presence_of :distributor_id, :date
  validates_uniqueness_of :date, scope: :distributor_id

  default_scope { order(:date) }

  scope :packed, -> { where(status: 'packed') }

  def self.collect_list(distributor, date)
    if distributor.packing_lists.where(date: date).count.positive?
      distributor.packing_lists.where(date: date).includes({ packages: {} }).first
    else
      order_ids = Bucky::Sql.order_ids(distributor, date)
      orders = distributor.orders.active.where(id: order_ids).includes({ account: { customer: { address: {}, deliveries: { delivery_list: {} } } }, order_extras: {}, box: {} })

      FuturePackingList.new(date, orders, false)
    end
  end

  def self.generate_list(distributor, date)
    packing_list = get(distributor, date)

    distributor.orders.active.where(id: Bucky::Sql.order_ids(distributor, date)).map do |order|
      packing_list.packages.originals.find_or_create_by(order_id: order.id)
    end

    packing_list
  end

  def ordered_packages(ids = nil)
    list_items = packages
    list_items = list_items.select { |item| ids.include?(item.id) } if ids
    list_items
  end

  def self.get(distributor, date)
    packing_list = PackingList.find_by_distributor_id_and_date(distributor.id, date)
    packing_list ||= PackingList.create!(distributor: distributor, date: date)
    packing_list
  end

  def mark_all_as_auto_packed
    packages.all? do |package|
      package.status = 'packed'
      package.packing_method = 'auto'
      package.save
    end
  end
end
