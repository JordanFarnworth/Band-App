class AddBandIdToFavorite < ActiveRecord::Migration
  def change
    add_column :favorites, :band_id, :integer
  end
end
