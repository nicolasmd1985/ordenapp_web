class Customers::Orders::ThingsToOrder

  def initialize(order_id, things_ids, old_things_ids)
    @order_id = order_id
    @things_ids = things_ids
    @old_things_ids = old_things_ids
  end

  def process
    things = Thing.where(id: @things_ids)
    old_things = Thing.where(id: @old_things_ids)

    # desasociate thing to the order, when from the order unselect some thing
    old_things.each do |thing|
      old_orders = thing.order_ids
      old_orders.delete(@order_id.to_s)
      thing.update(order_ids: old_orders)
    end

    # asociate thing with the order
    things.each do |thing|
      orders = thing.order_ids
      orders << @order_id.to_s
      orders.uniq!
      thing.update(order_ids: orders)
    end

    @things_ids
  end

end
