class Contact < ActiveRecord::Base

  belongs_to :band
  belongs_to :entity
  
end
