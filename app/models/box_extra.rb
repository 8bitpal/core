class BoxExtra < ActiveRecord::Base
  attr_accessor

  belongs_to :box
  belongs_to :extra

  # TODO: Shouldn't there be some validations here?
end
