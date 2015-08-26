class AddUserToEntity < ActiveRecord::Migration
  def change
    add_reference :entities, :user, index: true, foreign_key: true

    drop_table :entity_users
  end
end
