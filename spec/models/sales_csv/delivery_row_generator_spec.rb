require 'fast_spec_helper'
require_model 'row_generator', sub_dir: 'sales_csv'
require_model 'delivery_row_generator', sub_dir: 'sales_csv'

describe SalesCsv::DeliveryRowGenerator do
  let(:order) do
    double('order',
      delivery_service_name: 'rname',
      delivery_service_fee: 1.23,
      id: 1,
      customer: customer,
    )
  end
  let(:delivery) do
    double('delivery',
      formated_delivery_number: 01,
      status: 'pak',
      order: order,
      package: package,
      status_formatted: 'pending',
    )
  end
  let(:package) do
    double('package',
      id: 1,
      date: Date.parse('2013-04-11'),
      archived_address_details: address,
      short_code: 'c',
      archived_box_name: 'bname',
      archived_substitutions: 'sub',
      archived_exclusions: 'ex',
      extras_description: 'exd',
      price: 10.00,
      archived_consumer_delivery_fee: 1.00,
      total_price: 11.00,
      status: 'del',
      status_formatted: 'pending',
    )
  end
  let(:customer) do
    double('customer',
      decorate: double(
        number: 1,
        first_name: 'fname',
        last_name: 'lname',
        new?: true,
        email: 'em@ex.com',
        special_order_preference: 'pref',
        customer_labels: "label1,label2",
        account: double(default_payment_method: nil),
        account_balance: 100.00,
      )
    )
  end
  let(:address) do
    double('address',
      phones: double(default_number: 8888),
      address_1: 'street 1',
      address_2: 'apt 1',
      suburb: 'sub',
      city: 'city',
      postcode: 123,
      delivery_note: 'note',
    )
  end
  let(:row_generator) { SalesCsv::DeliveryRowGenerator.new(delivery) }

  describe '#generate' do
    it 'generates a array for conversion to csv row' do
      expect(row_generator.generate).to eq ["rname", 1, nil, 1, 1, "11 Apr 2013", 1, "fname", "lname", 8888, "label1,label2", "NEW", "street 1", "apt 1", "sub", "city", 123, "note", "c", "bname", "sub", "ex", "exd", 10.0, 1.23, 1.0, 11.0, 100.0, "Unknown", "em@ex.com", "pref", "pending", "pending"]
    end
  end
end

