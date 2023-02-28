class AddReferenceInstallTimeToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :install_time, :time
  end
end
