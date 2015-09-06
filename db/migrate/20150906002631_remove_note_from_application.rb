class RemoveNoteFromApplication < ActiveRecord::Migration
  def change
    remove_column :applications, :note, :text
  end
end
