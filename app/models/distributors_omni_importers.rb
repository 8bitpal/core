class DistributorsOmniImporters < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :omni_importer
end
