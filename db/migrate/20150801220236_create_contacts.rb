class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.date :from_date
      t.date :until_date
      t.text :message

      t.timestamps null: false
    end
  end
end
