class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'Entity'
  belongs_to :message_thread
  has_many :message_participants, through: :message_thread, dependent: :destroy
  has_many :entities, through: :message_participants
  acts_as_paranoid

  scope :chronological, -> { order(:created_at) }
  scope :reverse_chronological, -> { order(created_at: :desc) }
  scope :between_entities, -> (entity1, entity2) do
    joins("INNER JOIN message_threads mt ON mt.id = messages.message_thread_id
           INNER JOIN message_participants mp1 ON mp1.message_thread_id = mt.id AND mp1.entity_id = #{entity1.id}
           INNER JOIN message_participants mp2 ON mp2.message_thread_id = mt.id AND mp2.entity_id = #{entity2.id}")
    .where('mp1.deleted_at IS NULL AND mp2.deleted_at IS NULL')
  end

  validates_length_of :subject, in: 5..200
  validates_length_of :body, in: 5..20000
  validates_presence_of :sender

  after_create do
    message_thread.touch
  end

  def preview_text
    body[0, 100] + (body.length > 100 ? '...' : '')
  end
end
