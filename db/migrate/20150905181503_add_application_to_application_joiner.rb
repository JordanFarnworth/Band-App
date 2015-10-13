class AddApplicationToApplicationJoiner < ActiveRecord::Migration
  def change
    add_reference :application_joiners, :application, index: true, foreign_key: true
  end
end
