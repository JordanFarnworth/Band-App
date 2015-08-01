class AdApplication < ActiveRecord::Base
  belongs_to :band
  belongs_to :ad
end
