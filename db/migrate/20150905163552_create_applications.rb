class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :status
      t.date :start
      t.date :end
      t.text :note

      t.timestamps null: false
    end
  end
end
