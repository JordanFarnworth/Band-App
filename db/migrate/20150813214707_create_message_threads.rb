class CreateMessageThreads < ActiveRecord::Migration
  def change
    create_table :message_threads do |t|

      t.timestamps null: false
    end

    drop_table :message_participants
    drop_table :messages

    create_table :messages do |t|
      t.string :subject
      t.text :body
      t.integer :sender_id, index: true
      t.references :message_thread, index: true, foreign_key: true
      t.datetime :deleted_at

      t.timestamps null: false
    end

    create_table :message_participants do |t|
      t.references :message_thread, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true
      t.string :state
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
