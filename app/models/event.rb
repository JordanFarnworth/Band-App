class Event < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :band
  belongs_to :entity


end
