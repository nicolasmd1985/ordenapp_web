class AddInternalIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :internal_id, :string
  end
end
