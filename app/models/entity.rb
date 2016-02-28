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
  has_many :review_joiners
  has_many :reviews, through: :review_joiners
  has_many :ads
  has_many :notifications
  has_many :payments
  acts_as_paranoid
  geocoded_by :address

  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :braintree_customer_id, uniqueness: true
  validate :validate_data

  serialize :social_media, Hash
  store_accessor :data

  after_initialize do
    self.braintree_customer_id ||= SecureRandom.hex 8
    self.data ||= Hash.new
  end

  def add_user(user)
    self.user = user
    self.save
  end

  def active_and_owner_events
    @events = Event.joins(:event_joiners).where(event_joiners: { status: %w(accepted owner), entity_id: self.id })
  end

  def event_applications
    apps = []
    self.events.each do |event|
      event.applications.each do |app|
        apps << app.id
      end
    end
    apps
  end

  def accepted_events
    events = []
    ej = self.event_joiners.accepted.each do |e|
      events << e.event
    end
    events
  end

  def has_event_application?(event_id)
    @event_joiner = EventJoiner.where(event_id: event_id, entity_id: self.id, status: "application")
    if @event_joiner.any?
      return true
    else
      return false
    end
  end

  def has_application(party)
    if self.applications == []
      return false
    else
      a = self.applications
      a.each do |x|
        if x.party_id == party && x.status == 'pending'
            return true
        end
      end
      return false
    end
  end

  def geocode_address
    self.geocode
    self.save
  end

  def band_miles(miles)
    p = Party.new
    p.address = self.address
    p.geocode
    p.nearbys miles
  end

  def validate_data
  # TODO
  end

  def email
    data['email']
  end

  def update_subscription(duration)
    self.subscription_expires_at = Time.now if subscription_expires_at.nil? || subscription_expires_at < Time.now
    self.subscription_expires_at += duration
    save!
  end
end
