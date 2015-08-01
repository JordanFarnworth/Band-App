class AddEntityToContact < ActiveRecord::Migration
  def change
    add_reference :contacts, :entity, index: true, foreign_key: true
  end
end
