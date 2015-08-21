class AddLocationToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :address, :string
  end
end
