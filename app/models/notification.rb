class Notification < ActiveRecord::Base
  belongs_to :entity
  belongs_to :context, polymorphic: true

  acts_as_paranoid

  validates_inclusion_of :state, in: %w(unread read)

  before_validation do
    self.state ||= 'unread'
  end

  def mark_as_read!
    self.state = 'read'
    save!
  end

  def self.create_for_entity!(entity, context, msg)
    notification = Notification.new
    if entity.is_a?(Entity)
      notification.entity = entity
    else
      notification.entity_id = entity
    end
    notification.context = context
    notification.description = msg
    notification.save!
  end
end
