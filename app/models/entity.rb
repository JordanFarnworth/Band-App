class Entity < ActiveRecord::Base
  acts_as_paranoid

  has_many :ads
  has_many :message_participants, foreign_key: :entity_id
  has_many :favorites
  has_many :reviews

  validates :title, presence: true
  validates :owner, presence: true
  validates :description, presence: true

  serialize :social_media, Hash

end
