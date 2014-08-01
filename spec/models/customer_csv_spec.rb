require_relative '../../app/models/customer_csv'

describe CustomerCSV do
  let(:distributor)  { double('distributor') }
  let(:customer_ids) { [ 1, 2, 3 ] }
  let(:customer)     { double('customer') }
  let(:customers)    { [customer] }

  [ [ 'city' , 'Wellington' ], [ 'email', 'test@example.com' ] ].each do |field, value|
    def field.titleize; self; end # needed by CustomerCSV#headers

    context "with the field '#{field}' and value '#{value}'" do
      let(:fields) { [ field ] }

      before { allow(customer).to receive(field) { value } }

      describe '.generate' do
        before do
          allow(customers).to receive(:decorate) { customers }
          allow(distributor).to receive(:customers_for_export) { customers }
        end

        it 'returns a csv based on the distributor and customer ids' do
          csv = CustomerCSV.generate(distributor, customer_ids, fields)
          expect(csv).to eq("#{field}\n#{value}\n")
        end
      end

      describe '#generate' do
        it 'returns a csv based on customers' do
          customer_csv = CustomerCSV.instance
          csv = customer_csv.generate(customers, fields)
          expect(csv).to eq("#{field}\n#{value}\n")
        end
      end
    end
  end
end

