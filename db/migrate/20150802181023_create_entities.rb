class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :name
      t.string :type
      t.text :description
      t.text :social_media
      t.hstore :data
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :entities, :data, using: :gin
  end
end
