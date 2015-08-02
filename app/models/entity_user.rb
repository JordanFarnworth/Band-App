class EntityUser < ActiveRecord::Base
  belongs_to :entity
  belongs_to :user

  validates_presence_of :entity, :user
  validates_uniqueness_of :entity, scope: :user
  validates_inclusion_of :role, in: %w(owner manager member)

  before_validation do
    self.role ||= :member
  end
end
