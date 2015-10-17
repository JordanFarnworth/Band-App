class Event < ActiveRecord::Base
  has_many :event_joiners, dependent: :destroy
  has_many :entities, through: :event_joiners


  def destroy
    self.delete
  end

   def self.new_event(party_id, band_id)
      event = Event.create(:title => "event")
      event.save
      band_joiner = EventJoiner.create(:entity_id => 1, :event_id => event.id)
      band_joiner.save
      party_joiner = EventJoiner.create(:entity_id => 2, :event_id =>  event.id)
      party_joiner.save
  end

end
