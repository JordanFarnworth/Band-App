class Event < ActiveRecord::Base
  has_many :event_joiners, dependent: :destroy
  has_many :entities, through: :event_joiners

  scope :pending, -> { where(state: 'pending') }
  scope :accepted, -> { where(state: 'accepted') }
  scope :open, -> { where(allow_apply: true) }
  scope :declined, -> { where(state: 'declined') }

  def destroy
    self.delete
  end

  def set_state
    @joiners = []
    self.event_joiners.each do |ej|
      @joiners << ej.status
    end
    if @joiners.include?('pending') && @joiners.exclude?('declined') && @joiners.exclude?('accepted')
      self.state = 'pending'
    elsif @joiners.include?('declined') && @joiners.exclude?('pending') && @joiners.exclude?('accepted')
      self.state = 'declined'
    elsif @joiners.include?('application') && @joiners.exclude?('pending') && @joiners.exclude?('declined')
      self.state = 'has applications'
    elsif @joiners.include?('accepted') && @joiners.exclude?('pending') && @joiners.exclude?('declined') && @joiners.exclude?('application')
      self.state = 'accepted'
    end
    self.save
    self
  end

end
