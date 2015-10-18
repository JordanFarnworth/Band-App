class AddOwnerToFavorite < ActiveRecord::Migration
  def change
    add_column :favorites, :owner, :string
  end
end
