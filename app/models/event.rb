class Event < ActiveRecord::Base
  has_many :event_joiners
  has_many :entities, through: :event_joiners
end
