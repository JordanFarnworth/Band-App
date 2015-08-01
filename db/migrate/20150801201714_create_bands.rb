class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :name
      t.text :description
      t.text :social_media
      t.string :email
      t.integer :phone_number
      t.string :mailing_address
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :bands, :deleted_at
  end
end
