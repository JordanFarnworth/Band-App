class CreateApplicationJoiners < ActiveRecord::Migration
  def change
    create_table :application_joiners do |t|
      t.references :entity, index: true, foreign_key: true
      t.string :relation

      t.timestamps null: false
    end
  end
end
