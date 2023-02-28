class AddThingsIdsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :things_ids, :string, default: [].to_yaml
  end
end
