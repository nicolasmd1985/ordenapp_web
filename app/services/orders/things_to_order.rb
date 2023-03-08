class Orders::ThingsToOrder

  def initialize(order_id, customer_id, things_ids, old_things_ids)
    @order_id = order_id
    @customer_id = customer_id
    @things_ids = things_ids
    @old_things_ids = old_things_ids
  end

  def process
    @things_ids.shift
    things = Thing.where(id: @things_ids)
    old_things = Thing.where(id: @old_things_ids)

    # desasociate thing to the order, when from the order unselect some thing
    old_things.each do |thing|
      old_orders = thing.order_ids
      old_orders.delete(@order_id.to_s)
      thing.update(order_ids: old_orders)
    end

    things.each do |thing|
      orders = thing.order_ids
      orders << @order_id.to_s
      orders.uniq!
      thing.update(order_ids: orders, user_id: @customer_id)
    end

    @things_ids
  end

end
