class Notifications::CreateNotification

  def initialize(order, current_user)
    @order = order
    @current_user = current_user
  end

  def process
    notification = Notification.new
    notification.order_internal_id = @order.internal_id
    notification.order_status = @order.status.description
    notification.order_slug = @order.slug
    notification.supervisor_id = @order.supervisor_id
    notification.supervisor_name = "#{@order.try(:supervisor).try(:first_name)} #{@order.try(:supervisor).try(:last_name)}"
    notification.user_id = @current_user.id
    notification.user_name = "#{@current_user.try(:first_name)} #{@current_user.try(:last_name)}"
    notification.subsidiary_id = @order.subsidiary_id

    notification.save(validate: false)
    NotificationBroadcastJob.perform_later(notification)

    notification
  end

end
