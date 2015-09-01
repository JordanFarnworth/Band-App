class CreateEventJoiners < ActiveRecord::Migration
  def change
    create_table :event_joiners do |t|
      t.references :entity, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
