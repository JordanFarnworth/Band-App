class AddBandIdToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :band_id, :integer
  end
end
