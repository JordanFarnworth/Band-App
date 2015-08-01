class AddBandToFavorite < ActiveRecord::Migration
  def change
    add_reference :favorites, :band, index: true, foreign_key: true
  end
end
