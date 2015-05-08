class DeliverySequenceOrder < ActiveRecord::Base
  attr_accessible :address_hash, :day, :position, :delivery_service_id

  belongs_to :delivery_service

  after_save :update_dso # cache results on delivery model
  default_value_for :position, -1

  scope :ordered, order('position ASC')

  def self.update_ordering(new_master_list, delivery_service_id, day)
    new_address_hashes = new_master_list.sortables

    Delivery.transaction do
      # Update the dso to have the new order
      sql = ["UPDATE delivery_sequence_orders SET position = CASE address_hash
        #{new_master_list.to_a.collect { |address_hash, index| "WHEN '#{address_hash}' THEN #{index}" }.join(' ')} END
        WHERE delivery_service_id = ?
        AND day = ?
        AND delivery_sequence_orders.address_hash in (?);", delivery_service_id, day, new_address_hashes]
      execute_sql(sql)

      # Update the dso cache on the delivery model
      sql = ["UPDATE deliveries SET dso = delivery_sequence_orders.position
        FROM orders
        INNER JOIN accounts on orders.account_id = accounts.id
        INNER JOIN customers on accounts.customer_id = customers.id
        INNER JOIN addresses on customers.id = addresses.customer_id
        INNER JOIN delivery_sequence_orders on delivery_sequence_orders.address_hash = addresses.address_hash
        WHERE orders.id = deliveries.order_id
        AND deliveries.delivery_service_id = delivery_sequence_orders.delivery_service_id
        AND addresses.address_hash in (?)", new_address_hashes]
      execute_sql(sql)
    end
  end

private

  def self.execute_sql(sql_array)
    connection.execute(send(:sanitize_sql_array, sql_array))
  end

  def update_dso
    Delivery.matching_dso(self).each do |delivery|
      next if delivery.dso == position
      next if delivery.archived?
      delivery.dso = position
      delivery.save!
    end
  end

  def self.for_delivery(delivery)
    attrs = { delivery_service_id: delivery.delivery_service_id, address_hash: delivery.address.address_hash, day: delivery.delivery_list.date.wday }
    dso = DeliverySequenceOrder.find_by(attrs)
    dso ||= DeliverySequenceOrder.create(attrs)
    dso
  end

  def self.position_for(address_hash, wday, delivery_service_id)
    dso = DeliverySequenceOrder.find_by(address_hash: address_hash, day: wday, delivery_service_id: delivery_service_id)
    dso && dso.position
  end
end
