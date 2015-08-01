class AddEntityToReview < ActiveRecord::Migration
  def change
    add_reference :reviews, :entity, index: true, foreign_key: true
  end
end
