class AddAdToAdApplication < ActiveRecord::Migration
  def change
    add_reference :ad_applications, :ad, index: true, foreign_key: true
  end
end
