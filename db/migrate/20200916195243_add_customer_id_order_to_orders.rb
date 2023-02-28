class AddCustomerIdOrderToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :customer_id_order, :string
  end
end
