class User < ActiveRecord::Base
  EMAIL_PATTERN = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i

  has_one :entity
  has_one :band, class_name: 'Band'
  has_one :party, class_name: 'Party'
  has_many :api_keys

  acts_as_paranoid
  has_secure_password
  validates_uniqueness_of :username, :email, :registration_token
  validates_presence_of :username, :display_name, :email, :state, :registration_token
  validates_inclusion_of :state, in: %w(pending_approval active)
  validates_format_of :email, with: EMAIL_PATTERN

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
