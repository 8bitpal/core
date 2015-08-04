require 'fast_spec_helper'
require 'csv'
require_model 'generator', sub_dir: 'sales_csv'
require_model 'delivery_generator', sub_dir: 'sales_csv'
required_constants %w(DeliveryRowGenerator)

describe SalesCsv::DeliveryGenerator do
  let(:empty_data)    { [] }
  let(:some_data)     { (1..10).to_a }
  let(:csv_row)       { double('csv_row') }
  let(:row_generator) { double('row_generator', new: csv_row) }

  describe '#generate' do
    after do
      delivery_generator = SalesCsv::DeliveryGenerator.new(@args, row_generator: row_generator)
      expect(delivery_generator.generate).to eq @expected_result
    end

    it 'generates a csv without data' do
      allow(csv_row).to receive(:generate) { empty_data }
      @args = []
      @expected_result = expected_csv_header
    end

    it 'generates a csv with data' do
      allow(csv_row).to receive(:generate) { some_data }
      @args = [double('item1')]
      @expected_result = expected_csv_header + "1,2,3,4,5,6,7,8,9,10\n"
    end
  end

  def expected_csv_header
    [
      'Delivery Service',
      'Delivery Sequence Number',
      'Order Number',
      'Package Number',
      'Delivery Date',
      'Customer Number',
      'Customer First Name',
      'Customer Last Name',
      'Customer Phone',
      'Customer Labels',
      'New Customer',
      'Delivery Address Line 1',
      'Delivery Address Line 2',
      'Delivery Address Suburb',
      'Delivery Address City',
      'Delivery Address Postcode',
      'Delivery Note',
      'Box Contents Short Description',
      'Box Type',
      'Box Likes',
      'Box Dislikes',
      'Box Extra Line Items',
      'Price',
      'Delivery Fee',
      'Bucky Box Transaction Fee',
      'Total Price',
      'Customer Account Balance',
      'Customer Payment Method',
      'Customer Email',
      'Customer Special Preferences',
      'Package Status',
      'Delivery Status',
    ].to_csv
  end
end
