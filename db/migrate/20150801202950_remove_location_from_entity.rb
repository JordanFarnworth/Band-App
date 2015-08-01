class RemoveLocationFromEntity < ActiveRecord::Migration
  def change
    remove_column :entities, :location, :string
  end
end
