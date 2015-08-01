class Band < ActiveRecord::Base
  acts_as_paranoid

  has_many :ad_applications
  has_many :ads, through: :ad_applications
  has_many :message_particiapnts, foreign_key: :entity_id
  has_many :reviews

  validates :name, presence: true
  validates :owner, presence: true
  validates :email, uniqueness: true
                    presence: true
  vaidates :phone_number, presence: true
  validates :mailing_address, presence: true

  serialize :social_media, Hash

end
