class Favorite < ActiveRecord::Base

  scope :band, -> { where(owner: 'band') }
  scope :party, -> { where(owner: 'party') }

  def party
    Party.find self.party_id
  end

  def band
    Band.find self.band_id
  end

  def destroy
    self.delete
  end
end
