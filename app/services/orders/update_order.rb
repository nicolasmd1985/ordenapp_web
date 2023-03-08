class Orders::UpdateOrder
  include OrdersHelper

  def initialize(order, params, current_user, tecnic = '', parent, parent_order, order_type, old_status)
    @order = order
    @params = params
    @current_user = current_user
    @tecnic = tecnic
    @parent = parent
    @parent_order = parent_order
    @order_type = order_type
    @old_status = old_status
  end

  def process
    cityId = Users::CreateCity.new(@params[:city_value], @params[:place_id], @params[:country_id]).create
    @tecnic_list = @params[:tecnic_id]
    @params[:customer_id] = @params[:customer_id].to_i if @params[:customer_id]
    @params[:install_time] = set_data_time(@params)
    @params[:limit_time] = @params[:install_time] + set_offset_time(@params)

    @order.description = @params[:description]
    @order.comment = @params[:comment]
    @order.address = @params[:address]
    @order.install_date = cast_install_date(@params[:install_date]).to_datetime
    @order.install_time = @params[:install_time]
    @order.limit_time = @params[:limit_time]
    @order.supervisor_id = @current_user.id.to_i
    @order.customer_id = @params[:customer_id]
    @order.category_id = @params[:category_id]
    @order.status_id = @params[:tecnic_id].blank? ? 500 : (@params[:tecnic_id][0].to_i == @order.tecnic_id ? @order.status_id : 501)
    # No tecnic = 500 if tecnic and is the same status remainds, otherwise is reassigned = 501
    @order.tecnic_id = @params[:tecnic_id].blank? ? nil : (@tecnic.blank? ? @tecnic_list[0].to_i : @tecnic)
    @order.customer_id_order = @params[:customer_id_order]
    @order.city_id =  cityId
    @order.parent_order = @parent_order.to_i
    @order.order_type = @order_type
    @order.parent = @parent

    success = @order.save

    log_created, log = Orders::CreateOrderLog.new(@order, "update", @current_user, @order.saved_changes).process if @order.saved_changes?

    # if order hasn't tecnic
    @order.update(status_id: 500) unless @order.tecnic_id?
    @order.update(substatus_id: nil) if @order.status_id == 500

    # if order is reassigned so is desynchronized
    @order.update(sync: false, substatus_id: nil) if @order.status_id == 501

    if (@old_status == 505 || @old_status == 500) && !@order.tecnic_id.blank?
      OrderMailer.order_assigned_mail(@order).deliver_later(wait: 1.minute)
      @user = User.find(@order.tecnic_id)
      notification = Users::CloudNotificationApp.new(@user, @order)
      notification.process
    end

    Notifications::CreateNotification.new(@order, @current_user).process if @old_status != @order.status_id

    [success, @order]
  end

  private

  def set_data_time(params)
    times = params[:install_date].to_s + " " + params[:install_time].to_s
    Time.parse(times)
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
