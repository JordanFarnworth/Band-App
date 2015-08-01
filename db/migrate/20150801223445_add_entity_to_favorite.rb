class AddEntityToFavorite < ActiveRecord::Migration
  def change
    add_reference :favorites, :entity, index: true, foreign_key: true
  end
end
