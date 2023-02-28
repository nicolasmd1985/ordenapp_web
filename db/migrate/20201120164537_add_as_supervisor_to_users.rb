class AddAsSupervisorToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :as_supervisor, :boolean, default: false
  end
end
