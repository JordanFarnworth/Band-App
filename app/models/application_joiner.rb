class ApplicationJoiner < ActiveRecord::Base
  belongs_to :entity
  belongs_to :application
end
