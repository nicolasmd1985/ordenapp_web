class AddOutThingToPositions < ActiveRecord::Migration[5.2]
  def change
    add_column :positions, :out_thing_id, :integer
    add_index :positions, :out_thing_id
  end
end
