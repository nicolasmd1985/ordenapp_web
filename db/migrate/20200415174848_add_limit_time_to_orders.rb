class AddLimitTimeToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :limit_time, :datetime
  end
end
