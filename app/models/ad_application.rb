class AdApplication < ActiveRecord::Base
  belongs_to :ad
  belongs_to :entity
end
