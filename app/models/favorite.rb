class Favorite < ActiveRecord::Base

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
