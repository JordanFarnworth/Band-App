class Review < ActiveRecord::Base
  has_many :review_joiners
end
