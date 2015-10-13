class CreateReviewJoiners < ActiveRecord::Migration
  def change
    create_table :review_joiners do |t|
      t.references :entity, index: true, foreign_key: true
      t.references :review, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
