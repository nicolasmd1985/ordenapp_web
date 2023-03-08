class Orders::CreateOrder
  include OrdersHelper

  def initialize(params, current_user, tecnic = '', parent, parent_order, order_type)
    @params = params
    @current_user = current_user
    @tecnic = tecnic
    @parent = parent
    @parent_order = parent_order
    @order_type = order_type
  end

  def process
    @order = Order.new
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
    @order.subsidiary_id = @current_user.subsidiary_id
    @order.supervisor_id = @current_user.id.to_i
    @order.customer_id = @params[:customer_id]
    @order.category_id = @params[:category_id]
    @order.contact = @params[:contact]
    @order.phone_contact = @params[:phone_contact]
    @order.tecnic_id = @params[:tecnic_id].blank? ? nil : (@tecnic.blank? ? @tecnic_list[0].to_i : @tecnic)
    @order.customer_id_order = @params[:customer_id_order]
    @order.status_id = @params[:tecnic_id].blank? ? 500 : 501
    @order.city_id = cityId
    @order.parent_order = @parent_order.to_i
    @order.order_type = @order_type
    @order.parent = @parent

    success = @order.save
    @order.update(customer_id_order: @order.internal_id) if @order.customer_id_order.blank?

    if success && @order.status_id == 501
      @user = User.find(@order.tecnic_id)
      OrderMailer.order_created_mail(@order).deliver_later(wait: 1.minute)
      OrderMailer.order_created_tech_mail(@order).deliver_later(wait: 1.minute)
      notification = Users::CloudNotificationApp.new(@user, @order)
      notification.process
    end

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
