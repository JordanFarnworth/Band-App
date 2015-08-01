class AddEntityToEvent < ActiveRecord::Migration
  def change
    add_reference :events, :entity, index: true, foreign_key: true
  end
end
