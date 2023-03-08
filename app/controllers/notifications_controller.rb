class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :supervisor?

  rescue_from ActiveRecord::RecordNotFound do |e|
    redirect_to notifications_url, aler: "Notification not found."
  end

  def index
    @notifications = Notification.notifications(current_user)
  end

  def show
    @notification = Notification.find_by(slug: params[:slug])

    if @notification
      @notification.update(readed: true, read_at: Time.now) unless @notification.readed
    else
      redirect_to notifications_url, alert: "Notification not found."
    end
  end

  def read_notifications
    unread = Notification.unread(current_user)
    unread.update_all(readed: true, read_at: Time.now) if unread
    redirect_to notifications_url, notice: "Notifications readed."
  end

  def delete_notifications
    notifications = Notification.notifications(current_user)
    notifications.delete_all if notifications
    redirect_to notifications_url, notice: "Notifications deleted."
  end

  def delete_readed_notifications
    readed = Notification.readed(current_user)
    readed.delete_all if readed
    redirect_to notifications_url, notice: "Readed notifications deleted."
  end

end
