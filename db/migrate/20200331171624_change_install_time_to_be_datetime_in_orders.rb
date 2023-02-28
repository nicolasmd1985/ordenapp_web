class ChangeInstallTimeToBeDatetimeInOrders < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :install_time, :time
  end
end
