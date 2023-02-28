class AddOriginToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :origin, :string, default: 'Operation'
  end
end
