class Api::V1::OrdersController < ApiController
  before_action :authorize_request, except: [:tecnic_availability]
  before_action :find_order, only: %i[show update destroy]
  before_action :set_order, only: %i[desync notify_status arrives]

  def index
    @orders_json = []
    orders =  Order.orders_tecnic(current_user.id)
    orders.each do |o|
      @orders_json <<{
        "id_order" => o.id,
        "tecnic_id" => o.tecnic_id,
        "description" => o.description,
        "address" => o.address,
        "contact" => o.contact,
        "phone_contact" => o.phone_contact,
        "customer_id" => o.customer_id,
        "city_id" => City.find(o.city_id).name,
        "created_at" => o.created_at,
        "install_time" => o.install_time.strftime("%F %I:%M%p"),
        "limit_time" => set_diff_hours(o),
        "category_id" => Category.find(o.category_id).name,
        "comment" => o.comment
      }
    end
    render json: @orders_json, status: :ok
  end

  def show
    render json: @order, status: :ok
  end

  def create
    if params[:aux_order].present?
      order_params = params[:aux_order]
      @subsidiary = Subsidiary.find current_user.subsidiary_id
      @order = Order.new
      @order.status_id = 502
      @order.tecnic_id = current_user.id
      @order.supervisor_id = @subsidiary.users.find_by(role: "supervisor").id
      @order.install_date = order_params[:install_time]
      @order.install_time = order_params[:install_time]
      @order.customer_id = order_params[:customer_id]
      @order.created_at = order_params[:created_at]
      @order.city_id = City.find_by(name: order_params[:city_id]).id
      @order.subsidiary_id = current_user.subsidiary_id
      @order.sync = true
      @order.description = EnsureUtf8Encode.new(order_params[:description]).process
      @order.address = EnsureUtf8Encode.new(order_params[:address]).process
      @order.category_id = Category.find_by(name: order_params[:category_id]).id
      limitTime = order_params[:limit_time].split("-")
      @order.limit_time = order_params[:install_time].to_time + set_data_time(limitTime)
      if @order.save!
        log_created, log = Orders::CreateOrderLog.new(@order, "create", current_user).process
        OrderMailer.order_created_mail(@order).deliver_later
        render json: @order.id , status: :ok
      else
        render json: { errors: @order.errors.full_messages, status: :unprocessable_entity}
      end
    end
  end

  def update
    if @order.update(order_params)
      log_created, log = Orders::CreateOrderLog.new(@order, "update", current_user, @order.saved_changes).process if @order.saved_changes?
      render json: @order, status: :ok
    else
      render json: { errors: @order.errors.full_messages, status: :unprocessable_entity }
    end
  end

  def destroy
    @order.destroy
  end

  # endpoint to change sync value
  def sync
    @list = params[:_json] #read json array
    @list.values.each do |value| # loop on list array
      @order = Order.find(value[:id_order]) #find the order
      @order.status_id = 502
      @order.sync = true #change order's sync value
      @order.save # save
      log_created, log = Orders::CreateOrderLog.new(@order, "sync", current_user).process
      Notifications::CreateNotification.new(@order, current_user).process
    end
    render json: {message: "Sync OK"}, status: :ok
  end

  # endpoint to desync orders
  def desync
    @order.status_id = 505
    @order.tecnic_id = nil
    @order.sync = false
    @order.save
    log_created, log = Orders::CreateOrderLog.new(@order, "Desync", current_user).process
    Notifications::CreateNotification.new(@order, current_user).process
    render json: {message: "Desync OK"}, status: :ok
  end

  def arrives
    latitude = params[:latitude] if params[:latitude].present?
    longitude = params[:longitude] if params[:longitude].present?
    position_service = Gps::GpsDataUser.new(latitude, longitude, current_user.id).process

    if position_service
      user = current_user
			user.update(status_id: 203) #Busy
      @order.update(status_id: 510) #In progress

      log_created, log = Orders::CreateOrderLog.new(@order, "Arrives place", current_user, @order.saved_changes).process
      Gps::CreatePositionLog.new(user, position_service).process
      Notifications::CreateNotification.new(@order, current_user).process

      render json: {message: "Arrives OK"}, status: :ok
    else
      render json: {errors: "Failed to save position."}, status: :unprocessable_entity
    end
  end

  def notify_status
    @order.status_id = params[:status] if params[:status].present?
    @order.substatus_id = params[:substatus] if params[:substatus].present?
    @order.save
    render json:{message: "OK", order: @order}, status: :ok
  end

  def order_starts
    @position = Position.new(position_params)
		@position.user_id = current_user.id

    if @position.save
      @order.update(status_id: 510)
      log_created, log = Orders::CreateOrderLog.new(@order, "Arrives place", current_user, @order.saved_changes).process
      render json: {order: @order, position: @position, log: log}
    else
      render json: {errors: @position.errors.full_messages, message: "Failed to update order."}, status: :unprocessable_entity
    end
  end

  def done_substatuses
    @substatuses = Substatus.where(status_id: 504)
    render json: @substatuses, status: :ok
  end

  def pending_substatuses
    @substatuses = Substatus.where(status_id: 506)
    render json: @substatuses, status: :ok
  end

  def receivable_substatuses
    @substatuses = Substatus.where(status_id: 507)
    render json: @substatuses, status: :ok
  end

  def service_center_substatuses
    @substatuses = Substatus.where(status_id: 508)
    render json: @substatuses, status: :ok
  end

  def tecnic_availability

    if params[:tecnic_id].present? && params[:install_date].present?
      @orders = Order.where(tecnic_id: params[:tecnic_id],install_date: params[:install_date],status_id: 501)

        if !@orders.empty?
          @nro_orders = @orders.count


          ordenes =[]
          @orders.each do |order|
            horai = order.install_time.strftime("%I:%M%p")
            horaf = order.limit_time.strftime("%I:%M%p")

            if params[:install_time].present? && params[:limit_time].present?

              start_time = order.install_time.strftime("%F %I:%M%p").to_datetime
              limit_time = order.limit_time.strftime("%F %I:%M%p").to_datetime
              estimate_start_time = params[:install_time].to_datetime.strftime("%F %I:%M%p").to_datetime
              estimate_end_time = params[:limit_time].to_datetime.strftime("%F %I:%M%p").to_datetime

              conflict = (start_time...limit_time).overlaps?(estimate_start_time...estimate_end_time)


              if order.id != params[:order_id].to_i

                @orders_overlapped =+ 1
                ordenes << {id: order.id, internal_id: order.internal_id, descripcion: order.description, hora_inicial: horai, hora_fin: horaf, direccion: order.address, cruza: conflict}

              end

            end
          end
          render json: { qty: @nro_orders, overlap: @orders_overlapped, ordenes: ordenes } , status: :ok
        else
          @nro_orders = "No tiene ordenes para el dia seleccionado dia"
          render json: { qty: @nro_orders }, status: :ok
        end
    else
      @nro_orders = "No indico fecha y/o tecnico a consultar"
      render json: { qty: @nro_orders }, status: :ok
    end
  end


  private

    def find_order
      @order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
    end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.permit(:description, :address, :priority,:sync, :supervisor_id, :tecnic_id, :install_date, :install_time, :status_id, :city_id, :customer_id, :subsidiary_id, :corporation_id)
    end

    def set_data_time params
      if params[1] == "horas"
        params[0].to_i.hour
      else
        params[0].to_i.days
      end
    end

    def set_diff_hours(order)
      unless order.limit_time.nil?
        @seg = (order.limit_time - order.install_time)/3600
        if @seg > 24
          return @seg = "#{@seg/24} days"
        elsif @seg < 1
          return @seg = "#{@seg*60} minutes"
        else
          return @seg = "#{@seg} hour"
        end
      end
      return @seg = "1 hour"
    end

end
