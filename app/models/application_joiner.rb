class ApplicationJoiner < ActiveRecord::Base
  belongs_to :entity
  belongs_to :application

  def create_band_joiner(band, application)
    self.entity_id = band
    self.application_id = application
    self.relation = 'requestor'
    self.save
  end

  def create_party_joiner(party, application)
    self.entity_id = party
    self.application_id = application
    self.relation = 'requestee'
    self.save
  end
end
