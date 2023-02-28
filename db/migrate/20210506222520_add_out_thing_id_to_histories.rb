class AddOutThingIdToHistories < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :out_thing_id, :integer
    add_index :histories, :out_thing_id
  end
end
