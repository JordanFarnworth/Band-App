class MessageParticipant < ActiveRecord::Base
  belongs_to :message
  belongs_to :entity
  acts_as_paranoid

  scope :unread, -> { where(state: :unread) }

  validates_presence_of :message, :entity
  validates_inclusion_of :state, in: %w(unread read)

  before_validation do
    self.state ||= :unread
  end
end
