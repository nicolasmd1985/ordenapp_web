class Customers::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :customer?
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to customers_dashboard_url, notice: "Order not found"
  end

  def index
    if (params[:search].present? && !params[:search].blank?) ||
      (params[:sync].present? && !params[:sync].blank?) ||
      (params[:status].present? && !params[:status].blank?) ||
      (params[:tecnic].present? && !params[:tecnic].blank?) ||
      (params[:city].present? && !params[:city].blank?)
      @orders = Order.customer_search(current_user.subsidiary_id,
                                      current_user.id, params[:search],
                                      params[:sync], params[:status],
                                      params[:tecnic], params[:city])
                                      .where.not(status_id: 503).order(created_at: :desc)
      add_breadcrumb "#{t("base.bar_menu.orders.finish_list")}"
    else
      @orders = Order.customer_resquest_orders(current_user.subsidiary_id, current_user.id)
      add_breadcrumb "#{t("base.bar_menu.orders.list")}"
    end
    @sync = params[:sync].present? ? params[:sync] : ''
    @status = params[:status].present? ? params[:status] : ''
    @tecnic = params[:tecnic].present? ? params[:tecnic] : ''
    @city = params[:city].present? ? params[:city] : ''

  end

  def show
    if @order.customer_id == current_user.id
      @referral = Referral.find_by(order_id: @order.id.to_s)
      if @order.out_thing
        @histories = @order.out_thing.histories
      else
        @histories = History.where(order_id: @order.id)
      end

      respond_to do |format|
        format.html
        format.json
        format.pdf{render template: 'referrals/pdf/referralv2', pdf: 'referralv2', viewport_size: '1280x1024'}
      end
    else
      redirect_to customers_dashboard_url, notice: "This order is not registered"
    end
  end

  def new
    @order = Order.new
    add_breadcrumb "#{t("base.bar_menu.orders.support")}"
  end

  def edit
    if @order.status_id != 505
      redirect_to customer_order_url(@order.slug), notice: 'This Order already has been assigned.'
    end
  end

  def create
    things_ids = params[:things_ids].split(',')

    if things_ids.include?("0")
      things_ids.delete("0")
      if things_ids.size < 1 && params[:category_id].to_i != 101
        redirect_back(fallback_location: new_customer_order_url, alert: "Please chose a devise.")
        return
      end
    end

    @order = Order.new(order_params)
    @order.things_ids = things_ids
    @order.customer_id = current_user.id
    @order.subsidiary_id = current_user.subsidiary_id
    @order.status_id = 505
    @order.origin = params[:category_id].to_i == 101 ? 'Install' :'Support'

    if @order.save
      # things_ids = Customers::Orders::ThingsToOrder.new(@order.id, params[:things_ids], '').process
      # @order.update(things_ids: things_ids)
      history_created, @history = Histories::CreateHistory.new(@order, Thing.find(@order.things_ids[0]), nil, nil, nil).process if @order.origin != 'Install'
      log_created, log = ::Orders::CreateOrderLog.new(@order, "create", current_user).process
      OrderMailer.preorder_created_mail(@order).deliver_later(wait: 1.minute)
      redirect_to customer_order_url(@order.slug), notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  def update
    # old_things_ids = @order.things_ids
    # things_ids = Customers::Orders::ThingsToOrder.new(@order.id, params[:things_ids], old_things_ids).process
    # @order.things_ids = things_ids
    things_ids = params[:things_ids].split(',')

    if things_ids.include?("0")
      things_ids.delete("0")
      if things_ids.size < 1 && params[:category_id].to_i != 101
        redirect_back(fallback_location: edit_customer_order_url(@order.slug), alert: "Please chose a devise.")
        return
      end
    end

    @order.things_ids = things_ids

    if @order.update(order_params)
      history_created, @history = Histories::CreateHistory.new(@order, Thing.find(@order.things_ids[0]), nil, nil, nil).process if @order.origin != 'Install'
      log_created, log = ::Orders::CreateOrderLog.new(@order, "update", current_user, @order.saved_changes).process if @order.saved_changes?
      redirect_to customer_order_url(@order.slug), notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # 503 = "Rejected"
    @order.status_id = 503 if !@order.sync
    @order.save(validate: false)
    History.destroy(@order.histories.map{|x| x.id})
    redirect_to customers_orders_url, notice: "Order #{@order.internal_id} was successfully canceled."
  end

  private
  def set_order
    @order = Order.find_by(slug: params[:slug])
  end

  def order_params
    params.permit(:description, :address, :priority, :sync, :supervisor_id, :tecnic_id, :install_date, :install_time, :status_id, :city_id, :customer_id, :subsidiary_id, :category_id)
  end

end
