class Message < ActiveRecord::Base
  has_many :message_participants, dependent: :destroy
  has_many :entities, through: :message_participants
  belongs_to :sender, class_name: 'Entity'
  acts_as_paranoid

  scope :chronological, -> { order(:created_at) }
  scope :reverse_chronological, -> { order(created_at: :desc) }

  validates_length_of :subject, in: 5..200
  validates_length_of :body, in: 5..20000
  validates_presence_of :sender
end
