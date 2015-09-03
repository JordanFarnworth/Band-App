class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :recurrence_pattern
      t.datetime :recurrence_ends_at
      t.string :state
      t.integer :price

      t.timestamps null: false
    end
  end
end
