class AddLongitudeToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :longitude, :float
  end
end
