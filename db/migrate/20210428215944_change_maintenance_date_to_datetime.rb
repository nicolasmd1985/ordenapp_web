class ChangeMaintenanceDateToDatetime < ActiveRecord::Migration[5.2]
  def change
    change_column :things, :maintenance_date, :datetime
  end
end
