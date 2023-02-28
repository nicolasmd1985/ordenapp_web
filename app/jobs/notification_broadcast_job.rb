class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification)
    data = {notification: notification}
    ActionCable.server.broadcast("notification_channel", data)
  end
end
