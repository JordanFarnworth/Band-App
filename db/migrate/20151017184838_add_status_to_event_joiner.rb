class AddStatusToEventJoiner < ActiveRecord::Migration
  def change
    add_column :event_joiners, :status, :string
  end
end
