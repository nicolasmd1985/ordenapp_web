class AddParentToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :parent, :boolean, default: false
    add_column :orders, :parent_order, :integer
  end
end
