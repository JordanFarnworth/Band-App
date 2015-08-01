class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :title
      t.string :owner
      t.string :address
      t.string :location
      t.text :description
      t.text :social_media
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :entities, :deleted_at
  end
end
