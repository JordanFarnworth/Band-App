class Application < ActiveRecord::Base
  has_many :entities, through: :application_joiners
  has_many :application_joiners

  before_validation :infer_values

  validates_inclusion_of :status, in: %w(accepted pending declined deleted)

  def party
    Entity.find self.party_id
  end

  def band
    Entity.find self.band_id
  end

  def infer_values
    self.status ||= 'pending'
  end

  def accept_application
    self.status = 'accepted'
  end

  def decline_application
    self.status = 'declined'
  end

  def delete _application
    self.status = 'deleted'
  end

end
