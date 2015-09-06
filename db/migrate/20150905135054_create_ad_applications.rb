class CreateAdApplications < ActiveRecord::Migration
  def change
    create_table :ad_applications do |t|
      t.text :note
      t.string :state
      t.references :ad, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
