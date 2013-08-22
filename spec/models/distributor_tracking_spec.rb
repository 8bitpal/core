require 'spec_helper'

describe DistributorTracking do
  let(:distributor){ double('distributor').as_null_object }
  let(:distributor_tracking){ DistributorTracking.new(distributor) }
  let(:comms_tracking){ Bucky::CommsTracking.instance }

  describe '#tracking_after_create' do
    it 'passes call to CommsTracking' do
      tracking_data = double("tracking_data")
      distributor_tracking.stub(:tracking_data).and_return(tracking_data)

      comms_tracking.stub(:create_user).and_return(nil)
      comms_tracking.should_receive(:create_user).with(tracking_data, Rails.env)

      distributor_tracking.tracking_after_create
    end
  end

  describe '#tracking_after_save' do
    it 'updates tags' do
      comms_tracking.stub(:update_tags).and_return(nil)
      comms_tracking.should_receive(:update_tags)
      
      distributor_tracking.tracking_after_save
    end
  end
end
