class AddStartTimeToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :start_time, :date
  end
end
