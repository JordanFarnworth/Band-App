class Review < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :entity
  belongs_to :band

  validates_uniqueness_of :entity, scope: :band

end
