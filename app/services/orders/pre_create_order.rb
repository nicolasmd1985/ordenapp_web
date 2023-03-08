class Orders::PreCreateOrder

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def process
    @params[:tecnic_id].shift #clear the array removing the first posicion than is equal to ''
    @tecnic_list = @params[:tecnic_id]

    # clear 0 value
    if @tecnic_list.include?("0")
      @tecnic_list.delete("0")
      if @tecnic_list.size < 1
        # redirect_back(fallback_location: new_order_url, alert: "Please chose a technician.")
        # return
      end
    end

    if @tecnic_list.size > 1 #validate is groupal or single
      @parent = true
      @parent_order = 0
      @order_type = "Group"
    else
      @parent = false
      @parent_order = 0
      @order_type = "Single"
    end

    order_created, @order = Orders::CreateOrder.new(@params, @current_user, '', @parent, @parent_order, @order_type).process

    if order_created
      log_created, log = Orders::CreateOrderLog.new(@order, "create", @current_user).process
      # things_ids = Orders::ThingsToOrder.new(@order.id, @order.customer_id, @params[:order][:things_ids], '').process
      # @order.update(things_ids: things_ids)

      # if the order created become a parent call order create service to be groupal
      if @tecnic_list.size > 1 #validate is groupal or sigle to process to auto create children order with the other tecnics
        @tecnic_list.shift #remove the first tecnic to prevent duplicate the parent order
        @tecnic_list.each do |tecnic|
          order_created, order = Orders::CreateOrder.new(@params, @current_user, tecnic, false, @order.id, "Group").process
          log_created, log = Orders::CreateOrderLog.new(order, "create", @current_user).process
        end
      end
      [true, @order]
    else
      [false, false]
    end
  end

end
