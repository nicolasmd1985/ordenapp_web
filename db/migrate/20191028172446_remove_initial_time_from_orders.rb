class RemoveInitialTimeFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :initial_time, :datetime
    remove_column :orders, :final_time, :datetime
    remove_column :orders, :limit_time, :datetime
  end
end
