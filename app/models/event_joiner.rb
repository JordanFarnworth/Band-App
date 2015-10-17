class EventJoiner < ActiveRecord::Base
  belongs_to :entity
  belongs_to :event

  def self.create_band_ej(band_id, event_id)
    @ej = EventJoiner.new
    @ej.status = 'pending'
    @ej.entity_id = band_id
    @ej.event_id = event_id
    @ej.save
  end

  def self.create_party_ej(party_id, event_id)
    @ej = EventJoiner.new
    @ej.status = 'owner'
    @ej.entity_id = party_id
    @ej.event_id = event_id
    @ej.save
  end

end
