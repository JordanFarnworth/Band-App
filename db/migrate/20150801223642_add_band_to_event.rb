class AddBandToEvent < ActiveRecord::Migration
  def change
    add_reference :events, :band, index: true, foreign_key: true
  end
end
