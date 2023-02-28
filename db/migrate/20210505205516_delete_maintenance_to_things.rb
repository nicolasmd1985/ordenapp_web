class DeleteMaintenanceToThings < ActiveRecord::Migration[5.2]
  def change
    remove_column :things, :maintenance_date
    remove_column :things, :notification
    remove_column :things, :maintenance_frecuency_type
    remove_column :things, :maintenance_quantity
  end
end
