class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :supervisor?
  before_action :set_order, only: [:show, :edit, :update, :destroy, :close_order, :update_status, :reassign_tecnic]

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to dashboard_url, notice: "Order not found"
  end

  def index
    if (params[:search].present? && !params[:search].blank?) ||
      (params[:sync].present? && !params[:sync].blank?) ||
      (params[:status].present? && !params[:status].blank?) ||
      (params[:customer].present? && !params[:customer].blank?) ||
      (params[:tecnic].present? && !params[:tecnic].blank?) ||
      (params[:city].present? && !params[:city].blank?)
      @orders = Order.search(current_user.subsidiary_id,
                             params[:search], params[:sync],
                             params[:status], params[:customer],
                             params[:tecnic], params[:city]).where.not(status_id: 503)
    else
      @orders = Order.all_orders(current_user.subsidiary_id).order(created_at: :desc).where.not(status_id: 503)
    end
    @sync = params[:sync].present? ? params[:sync] : ''
    @status = params[:status].present? ? params[:status] : ''
    @customer = params[:customer].present? ? params[:customer] : ''
    @tecnic = params[:tecnic].present? ? params[:tecnic] : ''
    @city = params[:city].present? ? params[:city] : ''

    add_breadcrumb "#{t("base.bar_menu.orders.orders")}/#{t("base.bar_menu.orders.list")}"
  end

  def show
    if @order.supervisor_id == current_user.id || @order.subsidiary_id == current_user.subsidiary_id
      set_diff_hours
      @referral = Referral.find_by(order_id: @order.id.to_s)
      @histories = @order.out_thing.present? ? @order.out_thing.histories.where(origin: 'Mobile').order(created_at: :desc) : []
      @order_type = category_humanized(@order.category.nil? ? "" : @order.category.name)
      id = @order.customer_id_order? ? @order.customer_id_order : @order.internal_id
      respond_to do |format|
        format.html
        format.json
        format.pdf{render template: 'referrals/pdf/referralv2', pdf: "order-#{id}", viewport_size: '1280x1024'}
      end
    else
      redirect_to dashboard_url, notice: "This order is not registered in your subsidiary"
    end
  end

  def new
    @locale = params[:locale]
    @order = Order.new
    @thing = @order.try(:things).first
    add_breadcrumb "#{t("base.bar_menu.orders.orders")}/#{t("base.bar_menu.orders.new")}"
  end

  def edit
    city = City.find(@order.city_id)
    city_name = city.name
    country = Country.find(city.country_id)
    country_name = country.name
    @city_name = "#{city_name}, #{country_name}"
    @place_id = city.place_id
    @country_id = country.place_id
    set_diff_hours
  end

  def create
    if params[:order][:install_date].present? && params[:order][:time_data].present? && params[:order][:time_number].present? && params[:order][:tecnic_id].present?
      @tec_overlaped = Orders::CreateCheckOverlap.new(params[:order], current_user).process
        if @tec_overlaped
          redirect_back(fallback_location: new_order_url, alert: t('orders.index.err_2'))
          return
        else
          order_created, @order = Orders::PreCreateOrder.new(params[:order], current_user).process
          if order_created
            redirect_to order_url(@order.slug), notice: 'Order was successfully created.'
          else
            render :new
          end
        end
    else
      order_created, @order = Orders::PreCreateOrder.new(params[:order], current_user).process
      if order_created
        redirect_to order_url(@order.slug), notice: 'Order was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    if !@order.sync || [506, 507, 508].include?(@order.status_id)
      # if params[:order][:install_date].present? && params[:order][:install_date].to_date < Date.today
      #   redirect_to edit_order_url(@order.slug), alert: "Install date invalid. Can not be lower than current date."
      #   return
      # elsif params[:order][:install_date].present? && params[:order][:install_date].to_date == Date.today
        # if params[:order][:install_time].present? && params[:order][:install_time].to_time < Time.now
        #   redirect_to edit_order_url(@order.slug), alert: "Install time invalid. Can not be lower than current time."
        #   return
        # end
        # order_created, @order = Orders::PreUpdateOrder.new(@order, params[:order], current_user).process

      if params[:order][:install_date].present? && params[:order][:time_data].present? && params[:order][:time_number].present? && params[:order][:tecnic_id].present?
        @tec_overlaped = Orders::UpdateCheckOverlap.new(params[:order], current_user, @order).process

          if @tec_overlaped
            redirect_to edit_order_url(@order.slug), alert: "El tecnico ya tiene orden para esa hora y dia."
            return
          else
            order_created, @order = Orders::PreUpdateOrder.new(@order, params[:order], current_user).process
            if order_created
              redirect_to order_url(@order.slug), notice: 'Order was successfully updated.'
            else
              render :edit
            end
          end

        # if order_created
        #   redirect_to order_url(@order.slug), notice: 'Order was successfully updated.'
        # else
        #   render :edit
        # end
      else
        order_created, @order = Orders::PreUpdateOrder.new(@order, params[:order], current_user).process
        if order_created
          redirect_to order_url(@order.slug), notice: 'Order was successfully updated.'
        else
          render :edit
        end
      end

    else
      render :edit
    end
  end

  def update_status
    if [503, 506, 507, 508].include?(@order.status_id) && params[:status_id] != "0"
      @order.update_attributes(status_id: params[:status_id].to_i, substatus_id: params[:substatus_id].blank? ? nil : params[:substatus_id].to_i)

      params[:description] = "#{params[:status_id]} - #{params[:substatus_id]} - #{params[:comment]}"
      comment_created, comment = Comments::CreateComment.new(@order, @current_user, params).process
      log_created, log = Orders::CreateOrderLog.new(@order, "status changed", @current_user, @order.saved_changes).process

      Notifications::CreateNotification.new(@order, @current_user).process

      redirect_to order_url(@order.slug), notice: "Status updated to: #{@order.status.description}."
    else
      redirect_to order_url(@order.slug), alert: "Invalid status."
    end
  end

  def close_order
    if [507].include?(@order.status_id)
      @order.update_attributes(status_id: 504)
      log_created, log = Orders::CreateOrderLog.new(@order, "close", @current_user, @order.saved_changes).process
      OrderMailer.order_finished(@order)
      redirect_to order_url(@order.slug), notice: "Order closed successfully."
    else
      redirect_to order_url(@order.slug), alert: "Invalid status."
    end
  end

  def reassign_tecnic
    reassigned = Orders::ReassignTecnic.new(@order, current_user, params).process
    if reassigned
      redirect_to order_url(@order.slug), notice: "Order reassigned."
    else
      redirect_to order_url(@order.slug), alert: "Tecnic must be diferent to reassign order."
    end
  end

  def destroy
    # 503 = "Rejected"
    @order.status_id = 503 if !@order.sync
    @order.save(validate: false)
    History.destroy(@order.histories.map{|x| x.id})
    redirect_to orders_url, notice: "Order #{@order.internal_id} was successfully canceled."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find_by(slug: params[:slug])
    if params[:action] == 'update'
      @order = Order.find(params[:id])
    end
    @thing = @order.try(:things).first
    @customer = Order.order_user(@order.customer_id) if @order.customer_id.present?
    @full_name = "#{@customer.first_name} #{@customer.last_name}" if @customer.present?
    add_breadcrumb "#{t("base.bar_menu.orders.orders")}"
  end

  def set_diff_hours
    unless @order.limit_time.nil?
      @seg = (@order.limit_time - @order.install_time)/3600
      if @seg > 24
        return @seg = (@seg/24).to_i, @data = "days"
      elsif @seg < 1
        return @seg = (@seg*60).to_i, @data = "minutes"
      else
        return @seg = @seg.to_i, @data = "hour"
      end
    end
    return @seg = 1 ,  @data = "hour"
  end

  private
    def category_humanized(status)
      @status = status.to_s.gsub(/[\[\]]/, '')
      case @status
      when 'install'
        t('category.status.install')
      when 'maintenance'
        t('category.status.maintenance')
      when 'repair'
        t('category.status.repair')
      end
    end

end
