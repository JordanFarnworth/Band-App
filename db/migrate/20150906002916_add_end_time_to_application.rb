class AddEndTimeToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :end_time, :date
  end
end
