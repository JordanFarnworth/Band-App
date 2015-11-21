class AddLatitudeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :latitude, :string
  end
end
