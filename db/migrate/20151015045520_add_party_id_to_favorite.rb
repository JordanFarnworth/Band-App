class AddPartyIdToFavorite < ActiveRecord::Migration
  def change
    add_column :favorites, :party_id, :integer
  end
end
