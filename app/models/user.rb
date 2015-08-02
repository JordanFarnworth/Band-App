class User < ActiveRecord::Base
  has_many :entity_users
  has_many :entities, through: :entity_users
  has_many :bands, through: :entity_users, source: :entity, class_name: 'Band'
  has_many :parties, through: :entity_users, source: :entity, class_name: 'Party'

  acts_as_paranoid
  has_secure_password
  validates_uniqueness_of :username, :email
  validates_presence_of :username, :display_name, :email, :state
  validates_inclusion_of :state, in: %w(pending_approval active)

  scope :active, -> { where(state: :active) }

  before_validation do
    self.state ||= 'pending_approval'
  end
end
