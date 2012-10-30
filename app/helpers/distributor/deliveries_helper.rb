module Distributor::DeliveriesHelper
  CALENDAR_DATE_SIZE = 60

  def calendar_nav_length(dates, months)
    nav_length = dates.size + months.size

    return "width:#{nav_length * CALENDAR_DATE_SIZE}px;"
  end

  def date_class(date)
    'today' if date.today?
  end

  def count_selected(start_date, date_list, date)
    date = Date.parse(date) unless date.is_a?(Date)

    scroll_date = date - 1.week
    scroll_date = start_date if scroll_date < start_date

    if date == date_list
      element_id = 'selected'
    elsif scroll_date == date_list
      element_id = 'scroll-to'
    end

    return element_id
  end

  def count_class(current_distributor, date)
    if current_distributor.delivery_lists.where(date: date).count.zero?
      'out_of_range'
    elsif !current_distributor.delivery_lists.where(date: date).first.all_finished?
      'has_pending'
    end
  end

  def reschedule_dates(route)
    dates = route.schedule.next_occurrences(5, Time.current)
    options_from_collection_for_select(dates, 'to_date', 'to_date')
  end

  def order_delivery_route_name(order, date)
    delivery = order.delivery_for_date(date)
    delivery.route.name if delivery
  end

  def order_delivery_count(calendar_array, date, route = nil)
    data = calendar_array.select{|cdate, cdata| cdate == date}[0][1]

    if route
      Order.find(data[:order_ids]).select{|o| o.route(date) == route}.size
    else
      data[:order_ids].size
    end
  end

  def icon_display(status, icon_status)
    'display:none;' unless status == icon_status
  end

  def display_address(item)
    if item.is_a?(Order)
      link_to_google_maps(item.account.customer.address.address_1, item.account.customer.address.join)
    else
      item = item.package if item.is_a?(Delivery)
      link_to_google_maps(item.archived_address.split(', ').first, item.archived_address)
    end
  end

  def link_to_google_maps(address_shown, address_linked)
    address_linked = address_linked + ", #{[current_distributor.city, current_distributor.country.full_name].reject(&:blank?).join(", ")}"
    link_to address_shown, "http://maps.google.com/maps?q=#{Rack::Utils.escape(address_linked)}", target: '_blank'
  end

  def contents_description(item)
    if item.is_a?(Order)
      Package.contents_description(item.box, item.order_extras)
    else
      item = item.package if item.is_a?(Delivery)
      item.contents_description
    end
  end

  def delivery_quantity(distributor, date, route_id=nil)
    delivery_list = current_distributor.delivery_lists.where(date: date).first
    if delivery_list
      delivery_list.quantity_for(route_id)
    else
      Order.order_count(distributor, date, route_id)
    end
  end
end
