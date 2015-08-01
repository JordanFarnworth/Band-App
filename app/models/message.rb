class Message < ActiveRecord::Base
  acts_as_paranoid

  has_many :message_participants
end
