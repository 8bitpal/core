class DistributorsOmniImporters < ActiveRecord::Base
  attr_accessor :distributor_id, :omni_importer_id

  belongs_to :distributor
  belongs_to :omni_importer
end
