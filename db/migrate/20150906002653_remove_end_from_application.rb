class RemoveEndFromApplication < ActiveRecord::Migration
  def change
    remove_column :applications, :end, :date
  end
end
