class AddNotificationsToThings < ActiveRecord::Migration[5.2]
  def change
    add_column :things, :notification, :integer
    add_column :things, :notification_time, :string
  end
end
