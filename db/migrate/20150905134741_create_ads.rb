class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.text :description
      t.string :start_time
      t.string :location
      t.datetime :end_time
      t.string :state

      t.timestamps null: false
    end
  end
end
