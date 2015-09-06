class AddEntityToAd < ActiveRecord::Migration
  def change
    add_reference :ads, :entity, index: true, foreign_key: true
  end
end
