class AddOrderIdsToThings < ActiveRecord::Migration[5.2]
  def change
    add_column :things, :order_ids, :string, default: [].to_yaml
  end
end
