class AddReferenceInstallDateToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :install_date, :datetime
  end
end
