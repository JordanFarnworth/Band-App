class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :entity, index: true, foreign_key: true
      t.integer :context_id
      t.string :context_type
      t.text :description
      t.string :state
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
