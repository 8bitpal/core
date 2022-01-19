class UsercycleTriggerAcquisitionEvents < ActiveRecord::Migration[7.0]
  def up
    Distributor.all.each do |distributor|
      properties = {
        company: distributor.name,
        email: distributor.email,
        first_name: distributor.contact_name,
      }

      Bucky::Usercycle.instance.event(distributor, 'signed_up', properties, distributor.created_at)
    end
  end

  def down
    # noop
  end
end
