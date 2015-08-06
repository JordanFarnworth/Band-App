class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :body
      t.integer :sender_id, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
