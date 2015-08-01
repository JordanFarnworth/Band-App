class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :recurrence_pattern
      t.datetime :recurrence_ends_at
      t.string :state
      t.float :price
      t.string :price_options
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :events, :deleted_at
  end
end
