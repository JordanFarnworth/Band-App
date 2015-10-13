class RemoveStartFromApplication < ActiveRecord::Migration
  def change
    remove_column :applications, :start, :date
  end
end
