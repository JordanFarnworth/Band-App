class ReviewJoiner < ActiveRecord::Base
  belongs_to :entity
  belongs_to :review

  scope :reviewer, -> { where(state: :reviewer) }
  scope :reviewee, -> { where(state: :reviewee) }

end
