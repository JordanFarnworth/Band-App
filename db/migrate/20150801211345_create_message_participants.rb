class CreateMessageParticipants < ActiveRecord::Migration
  def change
    create_table :message_participants do |t|

      t.timestamps null: false
    end
  end
end
