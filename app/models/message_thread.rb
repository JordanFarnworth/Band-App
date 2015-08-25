class MessageThread < ActiveRecord::Base
  has_many :message_participants
  has_many :entities, through: :message_participants
  has_many :messages
  has_many :sorted_messages, -> { reverse_chronological }, foreign_key: 'message_thread_id', class_name: 'Message'
  has_one :latest_message, -> { reverse_chronological }, foreign_key: 'message_thread_id', class_name: 'Message'

  scope :with_entities, -> { includes(message_participants: :entity) }
  scope :with_messages, -> { includes(:sorted_messages) }
  scope :reverse_chronological, -> { joins(:messages).order('messages.created_at DESC') }

  def self.between_entities(entity1, entity2)
    joins("INNER JOIN message_participants mp1 ON mp1.message_thread_id = message_threads.id AND mp1.entity_id = #{entity1.id}
           INNER JOIN message_participants mp2 ON mp2.message_thread_id = message_threads.id AND mp2.entity_id = #{entity2.id}")
    .where("mp1.deleted_at IS NULL AND mp2.deleted_at IS NULL").first
  end
end
