class User < ActiveRecord::Base
  has_many :entity_users
  has_many :entities, through: :entity_users
  has_many :bands, through: :entity_users, source: :entity, class_name: 'Band'
  has_many :parties, through: :entity_users, source: :entity, class_name: 'Party'

  acts_as_paranoid
  has_secure_password
  validates_uniqueness_of :username, :email, :registration_token
  validates_presence_of :username, :display_name, :email, :state, :registration_token
  validates_inclusion_of :state, in: %w(pending_approval active)

  scope :active, -> { where(state: :active) }
  scope :pending, -> { where(state: :pending_approval) }

  before_validation do
    self.state ||= 'pending_approval'
    generate_registration_token unless registration_token
  end

  def generate_registration_token
    self.registration_token = SecureRandom.hex(32)
  end

  def confirm!
    self.state = :active
    save!
  end
end
