require 'spec_helper'

describe WebstoreOrder do
  let(:box)            { mock_model Box }
  let(:account)        { mock_model Account }
  let(:route)          { mock_model Route }
  let(:order)          { mock_model Order }
  let(:extra)          { mock_model Extra }
  let(:exclusion)      { mock_model Exclusion }
  let(:substitution)   { mock_model Substitution }
  let(:distributor)    { mock_model Distributor }
  let(:webstore_order) { Fabricate.build(:webstore_order) }

  subject { webstore_order }

  context 'box information' do
    before do
      box.stub(:thumb_url) { 'box.jpg' }
      box.stub(:currency) { 'CDN' }
      box.stub(:name) { 'Boxy' }
      box.stub(:price) { 12 }
      box.stub(:description) { 'A box.' }
      webstore_order.stub(:box) { box }
    end

    its(:thumb_url) { should eq('box.jpg') }
    its(:currency) { should eq('CDN') }
    its(:box_name) { should eq('Boxy') }
    its(:box_price) { should eq(12) }
    its(:box_description) { should eq('A box.') }
  end

  context 'route information' do
    before do
      route.stub(:name) { 'A Route' }
      route.stub(:fee) { 2 }
      account.stub(:route) { route }
      webstore_order.stub(:route) { route }
    end

    its(:route) { should eq(account.route) }
    its(:route_name) { should eq('A Route') }
    its(:route_fee) { should eq(2) }
  end

  context 'distributor information' do
    before do
      distributor.stub(:consumer_delivery_fee) { 0.25 }
      distributor.stub(:separate_bucky_fee?) { true }
      webstore_order.stub(:distributor) { distributor }
    end

    its(:bucky_fee) { should eq(0.25) }
    its(:has_bucky_fee?) { should be_true }
  end

  context 'status' do
    specify { expect { webstore_order.customise_step }.to change(webstore_order, :status).to(:customise) }
    specify { expect { webstore_order.login_step }.to change(webstore_order, :status).to(:login) }
    specify { expect { webstore_order.delivery_step }.to change(webstore_order, :status).to(:delivery) }
    specify { expect { webstore_order.complete_step }.to change(webstore_order, :status).to(:complete) }
    specify { expect { webstore_order.placed_step }.to change(webstore_order, :status).to(:placed) }

    describe '#customised?' do
      before do
        webstore_order.stub(:exclude) { [] }
        webstore_order.stub(:extras) { {} }
      end

      its(:customised?) { should be_false }

      context 'where there are excludes' do
        before { webstore_order.stub(:exclusions) { ['1'] } }
        its(:customised?) { should be_true }
      end

      context 'when there are extras' do
        before { webstore_order.stub(:extras) { {'1' => '2'} } }
        its(:customised?) { should be_true }
      end
    end

    describe '#scheduled?' do
      context 'when there is a schedule' do
        before { webstore_order.stub(:schedule_rule) { { start: Date.current } } }
        its(:scheduled?) { should be_true }
      end

      context 'when there is not a schedule' do
        before { webstore_order.stub(:schedule_rule) { nil } }
        its(:scheduled?) { should be_false }
      end
    end

    describe '#completed?' do
      context 'where the webstore order has been completed' do
        before { webstore_order.placed_step }
        its(:completed?) { should be_true }
      end

      context 'where the webstore order has not been completed' do
        its(:completed?) { should be_false }
      end
    end
  end

  describe '#extra_objects' do
    before do
      webstore_order.stub(:extras) { {1 => 1} }
      Extra.stub(:find_all_by_id).with([1]) { [extra] }
    end

    its(:extra_objects) { should eq([extra]) }
  end

  describe '#exclusion_objects' do
    before do
      webstore_order.stub(:exclusions) { [1] }
      LineItem.stub(:find_all_by_id).with([1]) { [exclusion] }
    end

    its(:exclusion_objects) { should eq([exclusion]) }
  end

  describe '#substitution_objects' do
    before do
      webstore_order.stub(:substitutions) { [1] }
      LineItem.stub(:find_all_by_id).with([1]) { [substitution] }
    end

    its(:substitution_objects) { should eq([substitution]) }
  end
end
