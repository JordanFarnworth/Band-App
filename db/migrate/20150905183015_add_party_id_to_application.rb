class AddPartyIdToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :party_id, :integer
  end
end
