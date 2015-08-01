class Ad < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :entity
  has_many :ad_applications
  has_many :applicants, through: :ad_applications, foreign_key: :band_id, class_name: 'Band'
end
