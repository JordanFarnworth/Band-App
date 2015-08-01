class Favorite < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :entity
  belongs_to :band
end
