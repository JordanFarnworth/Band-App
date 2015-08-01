class AddBandToAdApplication < ActiveRecord::Migration
  def change
    add_reference :ad_applications, :band, index: true, foreign_key: true
  end
end
