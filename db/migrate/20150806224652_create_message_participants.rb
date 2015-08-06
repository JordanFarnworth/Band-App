class CreateMessageParticipants < ActiveRecord::Migration
  def change
    create_table :message_participants do |t|
      t.references :message, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true
      t.string :state
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
