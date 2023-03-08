class Orders::PreUpdateOrder

  def initialize(order, params, current_user)
    @order = order
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

    # a single order can become in groupal or a child become a parent, this lose his parent order
    if @tecnic_list.size > 1 #validate is groupal or single
      @parent = true
      @parent_order = 0
      @order_type = "Group"
    else
      # validation to conservate data for a simple updating
      @parent = @order.parent ? true : false
      @parent_order = @order.parent ? 0 : @order.parent_order
      @order_type = @order.parent ? "Group" : (@order.try(:parents) ? "Group" : "Single")
    end

    @old_status = @order.status_id
    @old_tecnic = @order.tecnic_id
    old_things_ids = @order.things_ids
    # things_ids = Orders::ThingsToOrder.new(@order.id, @order.customer_id, @params[:order][:things_ids], old_things_ids).process
    # @order.things_ids = things_ids

    order_updated, @order = Orders::UpdateOrder.new(@order, @params, @current_user, '', @parent, @parent_order, @order_type, @old_status).process

    if order_updated
      # if the order updated become a parent call order create service to be groupal
      if @tecnic_list.size > 1 #validate is groupal or sigle to process to auto create children order with the other tecnics
        @tecnic_list.shift #remove the first tecnic to prevent duplicate the parent order
        @tecnic_list.each do |tecnic|
          order_created, order = Orders::CreateOrder.new(@params, @current_user, tecnic, false, @order.id, "Group").process
          log_created, log = Orders::CreateOrderLog.new(order, "create", @current_user).process
        end
      end

      if @old_tecnic != @order.tecnic_id
        @order.update(substatus_id: nil, status_id: 501, sync: false) if @order.status_id == 501
        log_created, log = Orders::CreateOrderLog.new(@order, "reassigned", @current_user, @order.saved_changes).process if @order.saved_changes?

        OrderMailer.order_assigned_mail(@order).deliver_later(wait: 1.minute)
        @user = User.find(@order.tecnic_id)
        notification = Users::CloudNotificationApp.new(@user, @order)
        notification.process
      end

      [true, @order]
    else
      [false, @order]
    end
  end

end
