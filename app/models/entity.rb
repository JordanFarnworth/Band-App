class Entity < ActiveRecord::Base
  include ActiveModel::Dirty
  has_many :entity_users
  has_many :users, through: :entity_users
  has_many :message_participants, dependent: :destroy
  has_many :message_threads, through: :message_participants
  has_many :messages, through: :message_threads
  has_many :unread_messages, -> { MessageParticipant.unread }, through: :message_participants,
    foreign_key: :entity_id, class_name: 'Message', source: :message
  acts_as_paranoid
  geocoded_by :address

  # ??? after_create :delay.geocode_address

  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validate :validate_data

  serialize :social_media, Hash
  store_accessor :data

  after_initialize do
    self.data ||= Hash.new
  end

  def geocode_address
    self.geocode
    self.save
  end

  def add_user(user, role = 'member')
    entity_user = entity_users.where(user: user).first_or_create
    entity_user.update! role: role unless entity_user.role == role
    entity_user
  end

  def validate_data
  end
end
