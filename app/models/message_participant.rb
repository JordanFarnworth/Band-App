class MessageParticipant < ActiveRecord::Base
  belongs_to :message
  belongs_to :entity
end
