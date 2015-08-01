class AddMessageToMessageParticipant < ActiveRecord::Migration
  def change
    add_reference :message_participants, :message, index: true, foreign_key: true
  end
end
