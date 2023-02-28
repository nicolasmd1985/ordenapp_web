class AddOutThingToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :out_thing_id, :integer
    add_index :orders, :out_thing_id
  end
end
