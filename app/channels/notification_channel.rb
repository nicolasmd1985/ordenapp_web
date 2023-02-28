class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # def count(data)
  #   binding.pry
  #   ActionCable.server.broadcast 'order_channel', order: data['order']
  # end
end
