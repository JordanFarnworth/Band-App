class EventJoiner < ActiveRecord::Base
  belongs_to :entity
  belongs_to :event

end
