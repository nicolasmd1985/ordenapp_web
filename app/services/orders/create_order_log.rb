class Orders::CreateOrderLog

  def initialize(order, action, current_user, data_log = nil)
    @order = order
    @action = action
    @current_user = current_user
    @data_log = data_log
  end

  def process
    @log = Orders::Log.new
    @log.action = @action
    @log.username = "#{@current_user.first_name} #{@current_user.last_name} (#{@current_user.role})"
    @log.status_description = @order.status.description
    @log.order_id = @order.id
    @log.user_id = @current_user.id
    @log.data_log = @data_log.to_a

    success = @log.save

    [success, @log]
  end

end
