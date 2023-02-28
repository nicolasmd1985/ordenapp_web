class Histories::CreateHistory

  def initialize(order, out_thing, tecnic_id, photos, args, origin = 'Support')
    @order = order
    @out_thing = out_thing
    @tecnic_id = tecnic_id
    @origin = origin
    @photos = photos
    @args_things = args
  end

  def process
    @history = History.new
    @history.description = @origin == "Mobile" ? @args_things[:comments] : @order.description
    @history.origin = @origin
    @history.out_thing_id = @out_thing.id
    @history.order_id = @order ? @order.id : nil
    @history.tecnic_id = @tecnic_id ? @tecnic_id : nil
    @history.photos = @photos ? @photos : nil
    @history.price = @args_things ? @args_things[:price].to_i : 0
    @history.quantity = @args_things ? @args_things[:quantity].to_i : 0
    @history.discount = @args_things ? @args_things[:discount].to_i : 0
    @history.customer_id = @out_thing ? @out_thing[:customer_id] : 0
    @history.warranty = @args_things ? @args_things[:warranty] : nil
    @history.time_install = @args_things ? @args_things[:time_install] : Time.now
    @history.substatus_id = @args_things[:product_status] ? @args_things[:product_status] : nil
    success = false
    if @history.save!
      success = true
      return [success, @history]
    else
      return [success, false]
    end
  end

end
