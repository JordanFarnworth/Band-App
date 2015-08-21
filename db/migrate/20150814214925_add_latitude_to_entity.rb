class AddLatitudeToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :latitude, :float
  end
end
