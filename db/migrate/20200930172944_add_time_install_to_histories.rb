class AddTimeInstallToHistories < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :time_install, :time
  end
end
