class Entity < ActiveRecord::Base
  include ActiveModel::Dirty
  belongs_to :user
  has_many :message_participants, dependent: :destroy
  has_many :message_threads, through: :message_participants
  has_many :messages, through: :message_threads
  has_many :unread_messages, -> { MessageParticipant.unread }, through: :message_participants,
    foreign_key: :entity_id, class_name: 'Message', source: :message
  has_many :event_joiners
  has_many :events, through: :event_joiners
  has_many :applications, through: :application_joiners
  has_many :application_joiners
  acts_as_paranoid
  geocoded_by :address

  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validate :validate_data

  serialize :social_media, Hash
  store_accessor :data

  after_initialize do
    self.data ||= Hash.new
  end

  def add_user(user)
    self.user = user
    self.save
  end

  def has_application(party)
    if self.applications === []
      return false
    else
      a = self.applications
      a.each do |x|
        if x.party_id === party
            return true
        else
          return false
        end
      end
    end
  end

  def geocode_address
    self.geocode
    self.save
  end

  def validate_data
  end
end
