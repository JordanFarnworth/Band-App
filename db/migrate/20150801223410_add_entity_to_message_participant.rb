class AddEntityToMessageParticipant < ActiveRecord::Migration
  def change
    add_reference :message_participants, :entity, index: true, foreign_key: true
  end
end
