class ChangeInstallDateToBeDateInOrders < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :install_date, :date
  end
end
