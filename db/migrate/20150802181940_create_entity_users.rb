class CreateEntityUsers < ActiveRecord::Migration
  def change
    create_table :entity_users do |t|
      t.references :entity, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :role

      t.timestamps null: false
    end
  end
end
