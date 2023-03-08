class Orders::ReassignTecnic
  include OrdersHelper

  def initialize(order, current_user, params)
    @order = order
    @current_user = current_user
    @params = params
    @old_status = @order.status_id
  end

  def process
    if @params[:tecnic_id].to_i == 0
      @order.update(sync: false, tecnic_id: @params[:tecnic_id].to_i, status_id: 500, substatus_id: nil)
      Notifications::CreateNotification.new(@order, @current_user).process if @old_status != @order.status_id

      return true
    end

    @params[:install_time] = set_data_time(@params)
    @params[:limit_time] = @params[:install_time] + set_offset_time(@params)

    @order.update(sync: false,
                              tecnic_id: @params[:tecnic_id].to_i,
                              install_date: cast_install_date(@params[:install_date]),
                              install_time: @params[:install_time],
                              limit_time: @params[:limit_time],
                              status_id: 501,
                              substatus_id: nil)

    log_created, log = Orders::CreateOrderLog.new(@order, "reassigned", @current_user, @order.saved_changes).process

    Notifications::CreateNotification.new(@order, @current_user).process if @old_status != @order.status_id

    @new_tecnic = User.find(@order.tecnic_id)
    OrderMailer.order_created_mail(@order).deliver_later(wait: 1.minute)
    OrderMailer.order_created_tech_mail(@order).deliver_later(wait: 1.minute)
    notification = Users::CloudNotificationApp.new(@new_tecnic, @order)
    notification.process

    true
  end

  private
    def set_data_time(params)
      times = params[:install_date].to_s + " " + params[:install_time].to_s
      Time.parse(cast_install_date(times))
    end

    def set_offset_time(params)
      case params[:time_data]
      when "minutes"
        params[:time_number].to_i.minutes
      when "hour"
        params[:time_number].to_i.hour
      when "days"
        params[:time_number].to_i.days
      end
    end

end
