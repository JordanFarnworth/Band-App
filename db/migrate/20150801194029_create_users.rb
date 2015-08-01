class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :display_name
      t.string :email
      t.string :password_digest
      t.string :state
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :users, :username
    add_index :users, :email
    add_index :users, :deleted_at
  end
end
