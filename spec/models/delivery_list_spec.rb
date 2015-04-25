require 'spec_helper'

describe DeliveryList, :slow do
  let(:distributor) { Fabricate.build(:distributor) }
  let(:delivery_service) { Fabricate.build(:delivery_service) }
  let(:delivery_list) { Fabricate.build(:delivery_list, distributor: distributor) }
  let(:delivery) { Fabricate.build(:delivery, delivery_list: delivery_list) }

  specify { expect(delivery_list).to be_valid }

  def delivery_auto_delivering(result = true)
    delivery = mock_model(Delivery)
    expect(Delivery).to receive(:auto_deliver).with(delivery).and_return(result)
    delivery
  end

  describe 'when marking all as auto delivered' do
    before do
      @deliveries = []
      delivery_list.stub_chain(:deliveries, :ordered).and_return(@deliveries)
    end

    it 'returns true if there are no deliveries' do
      expect(delivery_list.mark_all_as_auto_delivered).to be true
    end

    it 'returns true if all deliveries return true' do
      @deliveries << delivery_auto_delivering
      @deliveries << delivery_auto_delivering

      expect(delivery_list.mark_all_as_auto_delivered).to be true
    end

    it 'returns false if one delivery returns false' do
      @deliveries << delivery_auto_delivering
      @deliveries << delivery_auto_delivering(false)
      @deliveries << delivery_auto_delivering

      expect(delivery_list.mark_all_as_auto_delivered).to be false
    end
  end

  describe '.collect_list' do
    before do
      time_travel_to Date.parse('2013-05-01')

      @order = Fabricate(:recurring_order, completed: true)
      @distributor = @order.distributor
      @order.schedule_rule.recur = "monthly"
      @start_date = @order.schedule_rule.start

      @today = Date.parse('2013-05-08')
      time_travel_to @today

      @distributor.generate_required_daily_lists_between(@start_date, @today)
    end

    it "is a delivery day today" do
      expect(@today).to eq @order.schedule_rule.next_occurrence
    end

    it "works with the first week day" do
      delivery_date = @order.schedule_rule.next_occurrence
      delivery_list = DeliveryList.collect_list(@distributor, delivery_date)

      expect(delivery_list.deliveries).to eq [@order]
    end

    it "works with the nth week day" do
      @order.schedule_rule.week = 2
      delivery_date = @order.schedule_rule.next_occurrence
      expect(delivery_date).not_to be > @today

      delivery_list = DeliveryList.collect_list(@distributor, delivery_date)

      expect(delivery_list.deliveries).to eq [@order]
    end

    after { back_to_the_present }
  end

  describe '.generate_list' do
    before do
      time_travel_to Date.current

      @distributor = Fabricate(:distributor)
      daily_orders(@distributor)

      @advance_days  = Distributor::DEFAULT_ADVANCED_DAYS
      @generate_date = Date.current + @advance_days
      time_travel_to Date.current + 1.day
    end

    after { back_to_the_present }

    specify { expect { DeliveryList.generate_list(@distributor, @generate_date) }.to change(@distributor.delivery_lists, :count).from(@advance_days).to(@advance_days + 1) }
    specify { expect { PackingList.generate_list(@distributor, @generate_date); DeliveryList.generate_list(@distributor, @generate_date) }.to change(@distributor.deliveries, :count).from(0).to(3) }

    context 'for the next week' do
      before do
        PackingList.generate_list(@distributor, @generate_date)
        @dl1 = DeliveryList.generate_list(@distributor, @generate_date)
        PackingList.generate_list(@distributor, @generate_date + 1.week)
        @dl2 = DeliveryList.generate_list(@distributor, @generate_date + 1.week)
      end

      specify { expect(@dl2.deliveries.ordered.map{|d| "#{d.customer.number}/#{d.position}"}).to eq @dl1.deliveries.ordered.map{|d| "#{d.customer.number}/#{d.position}"} }

      context 'and the week after that' do
        before do
          PackingList.generate_list(@distributor, @generate_date + 2.week)
          @dl3 = DeliveryList.generate_list(@distributor, @generate_date + 2.week)
        end

        specify { expect(@dl3.deliveries.ordered.map{|d| "#{d.customer.number}/#{d.position}"}).to eq @dl2.deliveries.ordered.map{|d| "#{d.customer.number}/#{d.position}"} }
      end
    end

    after { back_to_the_present }
  end

  describe '#all_finished?' do
    before { delivery_list.save }

    context 'no deliveries are pending' do
      before do
        Fabricate(:delivery, status: 'delivered', delivery_list: delivery_list)
        Fabricate(:delivery, status: 'delivered', delivery_list: delivery_list)
      end

      specify { expect(delivery_list.all_finished?).to be true }
    end

    context 'has deliveries that are pending' do
      before do
        Fabricate(:delivery, status: 'delivered', delivery_list: delivery_list)
        Fabricate(:delivery, status: 'pending', delivery_list: delivery_list)
      end

      specify { expect(delivery_list.all_finished?).not_to be true }
    end
  end

  describe '#reposition' do
    context 'makes sure the deliveries are from the same delivery_service' do
      before do
        delivery_list.save
        delivery.save
        @diff_delivery_service = Fabricate(:delivery, delivery_list: delivery_list)
        allow(delivery_list).to receive(:delivery_ids).and_return([delivery, @diff_delivery_service])
      end

      specify { expect { delivery_list.reposition([@diff_delivery_service.id, delivery.id]) }.to raise_error(ArgumentError) }
    end

    context 'delivery ids must match' do
      before do
        @ids = [1, 2, 3]

        Delivery.stub_chain(:find, :delivery_service_id)
        Delivery.stub_chain(:find, :delivery_list, :date, :wday)
        delivery_list.stub_chain(:deliveries, :where, :select, :map).and_return(@ids)

        delivery_list.deliveries.stub_chain(:ordered, :find).and_return(delivery)
        allow(delivery).to receive(:reposition!).and_return(true)
      end

      specify { expect { delivery_list.reposition([2, 5, 3]) }.to raise_error(ArgumentError) }
    end

    context 'should update delivery list positions' do
      before do
        delivery_list.save
        allow_any_instance_of(DeliveryList).to receive(:archived?).and_return(false)
        d1 = fab_delivery(delivery_list, distributor)
        @delivery_service = d1.delivery_service
        d2 = fab_delivery(delivery_list, distributor, @delivery_service)
        d3 = fab_delivery(delivery_list, distributor, @delivery_service)
        @ids = delivery_list.reload.deliveries.ordered.collect(&:id)
        @new_ids = [@ids.last, @ids.first, @ids[1]]
      end

      it 'should change delivery order' do
        expect { delivery_list.reposition(@new_ids)}.to change{delivery_list.deliveries.ordered.collect(&:id)}.to(@new_ids)
        expect(delivery_list.reload.deliveries.ordered.collect(&:delivery_number)).to eq([3,1,2])
      end

      it 'should update the delivery list for the next week' do
        allow_any_instance_of(Distributor).to receive(:generate_required_daily_lists) # TODO: remove this hack to get around the constant after_save callbacks
        delivery_list.reposition(@new_ids)
        addresses = delivery_list.deliveries.ordered.collect(&:address)
        next_packing_list = PackingList.generate_list(distributor, delivery_list.date+1.week)
        next_delivery_list = DeliveryList.generate_list(distributor, delivery_list.date+1.week)
        allow_any_instance_of(Distributor).to receive(:generate_required_daily_lists).and_call_original # TODO: remove this hack to get around the constant after_save callbacks

        expect(next_delivery_list.deliveries.ordered.collect(&:address)).to eq(addresses)
        expect(next_delivery_list.deliveries.ordered.collect(&:delivery_number)).to eq([1,2,3])
      end

      it 'should put new deliveries at the top of the list' do
        allow_any_instance_of(DeliveryList).to receive(:archived?).and_return(false)
        date = delivery_list.date
        delivery_list.reposition(@new_ids)
        addresses = delivery_list.deliveries.ordered.collect(&:address)

        box = Fabricate(:box, distributor: distributor)
        account = Fabricate(:account, customer: Fabricate(:customer, distributor: distributor, delivery_service: @delivery_service))
        account2 = Fabricate(:account, customer: Fabricate(:customer, distributor: distributor, delivery_service: @delivery_service))
        order = Fabricate(:active_order, account: account, schedule_rule: new_single_schedule(date), box: box)
        order2 = Fabricate(:active_order, account: account2, schedule_rule: new_single_schedule(date), box: box)

        PackingList.generate_list(distributor, date)
        next_delivery_list = DeliveryList.generate_list(distributor, date)

        expect(next_delivery_list.deliveries.ordered.collect(&:address)).to eq([account2.address, account.address]+addresses)
        expect(next_delivery_list.deliveries.ordered.collect(&:delivery_number)).to eq([4,5,3,1,2])
      end
    end

    context 'with duplicate or similar addresses' do
      before do
        delivery_list.save
        delivery_service = Fabricate(:delivery_service, distributor: distributor)
        @d1 = fab_delivery(delivery_list, distributor, delivery_service)
        @d2 = fab_delivery(delivery_list, distributor, delivery_service)
        @d3 = fab_delivery(delivery_list, distributor, delivery_service)

        d1_address = @d1.order.address
        address = Fabricate.build(:address, address_1: d1_address.address_1, address_2: d1_address.address_2, suburb: d1_address.suburb, city: d1_address.city, delivery_note: "Im different")
        @d4 = fab_delivery(delivery_list, distributor, delivery_service, address)

        @ids = [@d1.id, @d2.id, @d3.id, @d4.id]
      end

      it 'should order deliveries by default to be in order of creation' do
        expect(delivery_list.deliveries.ordered.collect(&:id)).to eq(@ids)
      end

      it 'should keep similiar addresses together' do
        allow_any_instance_of(DeliveryList).to receive(:archived?).and_return(false)
        delivery_list.reposition(@ids)
        expect(delivery_list.deliveries.ordered.collect(&:id)).to eq([@d1.id, @d4.id, @d2.id, @d3.id])
      end

      it 'should give similiar addresses the same delivery number' do
        allow_any_instance_of(DeliveryList).to receive(:archived?).and_return(false)
        delivery_list.reposition(@ids)
        expect(delivery_list.deliveries.ordered.collect(&:delivery_number)).to eq([1, 1, 2, 3])
      end
    end
  end
end

def fab_delivery(delivery_list, distributor, delivery_service=nil, address=nil)
  delivery_service ||= Fabricate(:delivery_service, distributor: distributor, schedule_rule: Fabricate(:schedule_rule, start: Date.current.yesterday))

  customer = Fabricate(:customer, distributor: distributor, delivery_service: delivery_service)
  account = Fabricate(:account, customer: customer)

  customer.address.delete

  if address
    address.customer = customer
    address.save!
  else
    address = Fabricate(:address, customer: customer)
  end

  customer.address = address

  Fabricate(:delivery, delivery_list: delivery_list, order: Fabricate(:recurring_order_everyday, account: account), delivery_service: delivery_service)
end
