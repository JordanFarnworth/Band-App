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
    @joiners = []
    if self.event_joiners.count == 1
      self.state = 'No Invitations'
    else
      self.event_joiners.each do |ej|
        @joiners << ej.status
      end
      if @joiners.include?('pending') || @joiners.include?('application')
        self.state = 'pending'
      elsif @joiners.include?('declined')
        self.state = 'declined'
      else
        self.state = 'accepted'
      end
    end
    self.save
    self
  end

end
