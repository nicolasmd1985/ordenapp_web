class Orders::CreateCheckOverlap
  include OrdersHelper

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def process
    @tecnic = @params[:tecnic_id]
  
    @params[:install_time] = set_data_time(@params)
    @params[:limit_time] = @params[:install_time] + set_offset_time(@params)
    @orders = Order.where(tecnic_id: @params[:tecnic_id],install_date: @params[:install_date],status_id: 501)

    if !@orders.empty?
      @nro_orders = @orders.count
      ordenes =[]
      @orders.each do |order|
        start_time = order.install_time.strftime("%F %I:%M%p").to_datetime
        limit_time = order.limit_time.strftime("%F %I:%M%p").to_datetime
        estimate_start_time = @params[:install_time].to_datetime.strftime("%F %I:%M%p").to_datetime
        estimate_end_time = @params[:limit_time].to_datetime.strftime("%F %I:%M%p").to_datetime
        conflict = (start_time...limit_time).overlaps?(estimate_start_time...estimate_end_time)

        if conflict
          ordenes << {id: order.id, internal_id: order.internal_id, descripcion: order.description, hora_inicial: start_time, hora_fin: limit_time}
        end
      end

      if ordenes.empty?
        false
      else
        true
      end
    else
      false
    end
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
