class Users::CloudNotificationApp
  def initialize(user, order)
    @user = user
    @order = order
  end

  def process
    fcm = FCM.new(ENV['SERVER_MESSAGE_FIREBASE'])
    options = { "notification": {
      "title": "Nueva orden de trabajo",
      "body": @order.description
    }
  }
  token = @user.token_message
  response = fcm.send(token, options)

end

end
