class AddBandToReview < ActiveRecord::Migration
  def change
    add_reference :reviews, :band, index: true, foreign_key: true
  end
end
