class Event < ActiveRecord::Base
  has_many :event_joiners, dependent: :destroy
  has_many :entities, through: :event_joiners

  scope :pending, -> { where(state: 'pending') }
  scope :accepted, -> { where(state: 'accepted') }
  scope :no_invites, -> { where(state: 'No Invitations') }

  def destroy
    self.delete
  end

  def set_state
    if self.event_joiners == []
      self.state = 'No Invitations'
      return true
    end
  end

end
