class EventJoiner < ActiveRecord::Base
  belongs_to :entity
  belongs_to :event

  scope :pending, -> { where(status: 'pending') }
  scope :owner, -> { where(status: 'owner') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :deleted, -> { where(status: 'deleted') }
  scope :no_invitations, -> { where(status: 'No Invitations') }
  scope :application, -> { where(status: 'application' ) }

  def event
    Event.find self.event_id
  end

  def self.create_band_ej(band_id, event_id)
    @ej = EventJoiner.new
    @ej.status = 'pending'
    @ej.entity_id = band_id
    @ej.event_id = event_id
    @ej.save
  end

  def self.accept_band_ej(band_id, event_id)
    @ej = EventJoiner.new
    @ej.status = 'accepted'
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
