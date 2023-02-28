class AddMaintenanceDateToThings < ActiveRecord::Migration[5.2]
  def change
    add_column :things, :maintenance_date, :date
  end
end
