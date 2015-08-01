class User < ActiveRecord::Base
  acts_as_paranoid
  has_secure_password
  validates_uniqueness_of :username, :email
  validates_presence_of :username, :display_name, :email, :state
  validates_inclusion_of :state, in: %w(pending_approval active)

  before_validation do
    self.state ||= 'pending_approval'
  end
end
