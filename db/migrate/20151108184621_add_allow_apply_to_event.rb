class AddAllowApplyToEvent < ActiveRecord::Migration
  def change
    add_column :events, :allow_apply, :boolean
  end
end
