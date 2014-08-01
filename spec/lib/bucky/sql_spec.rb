require 'spec_helper'

describe Bucky::Sql do
  before do
    time_travel_to Date.parse('2013-05-01')

    @order = Fabricate(:recurring_order_everyday)
    @order.schedule_rule.recur = 'monthly'

    @distributor = @order.box.distributor
    @delivery_service = @distributor.delivery_services.first
  end

  after do
    back_to_the_present
  end

  %w(2013-05-02 2013-05-08 2013-05-15 2013-05-22).each_with_index do |date, week|
    context "with week = #{week}" do
      before do
        @order.schedule_rule.week = week
        @order.schedule_rule.save!

        @next_occurrence = @order.schedule_rule.next_occurrence
        @expected_delivery_date = Date.parse(date)
      end

      it "computes the expected next delivery date" do
        expect(@next_occurrence).to eq @expected_delivery_date
      end

      it "computes the expected second next delivery date" do
        second_next_occurrence = @order.schedule_rule.next_occurrence(@expected_delivery_date + 1.week)

        expect(second_next_occurrence).to be > @expected_delivery_date + 3.weeks
      end

      describe "#order_ids" do
        it "returns the orders" do
          order_ids = Bucky::Sql.order_ids(@distributor, @next_occurrence)

          expect(order_ids).to eq [@order.id]
        end
      end

      describe "#order_count" do
        it "returns the order count" do
          order_count = Bucky::Sql.order_count(@distributor, @next_occurrence, @delivery_service.id)

          expect(order_count).to eq 1
        end
      end
    end
  end
end
