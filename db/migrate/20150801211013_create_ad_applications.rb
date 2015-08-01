class CreateAdApplications < ActiveRecord::Migration
  def change
    create_table :ad_applications do |t|
      t.string :state

      t.timestamps null: false
    end
  end
end
