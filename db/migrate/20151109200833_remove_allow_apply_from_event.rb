class RemoveAllowApplyFromEvent < ActiveRecord::Migration
  def change
    remove_column :events, :allow_apply, :boolean
  end
end
