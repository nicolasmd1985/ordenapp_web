class Api::V1::NotificationsController < ApiController

  rescue_from Exception do |e|
    render json: {error: e.message}, status: :internal_error
  end

  def read
    id = params[:id].split('-')
    notification = Notification.find(id[1])
    notification.update(readed: true, read_at: Time.now) if notification
  end

end
