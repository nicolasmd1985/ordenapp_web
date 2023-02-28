class Things::GetData

  def initialize(things, order, subsidiary_id)
    @args_things = things
    @order = Order.find(order)
    @subsidiary_id = subsidiary_id
#    @referral = referral
  end

  def process
    cont = @args_things.length
    check = 0
    @args_things.each do |arg|
      arg[:photos] = JSON.parse(arg[:photos]) unless arg[:photos].nil?
      thg = Thing.where({code_scan: arg[:code_scan], subsidiary_id: @order.subsidiary_id}).first
      ott = OutThing.where(thing: thg, customer_id: @order.customer_id).first
      if ott
        @order.out_thing_id = ott.id
        @order.save
        # exists_thing.comments = EnsureUtf8Encode.new(arg[:comments]).process
        # exists_thing.order_ids << @order.id
        position_service = Gps::GpsDataThing.new(arg[:latitude], arg[:longitude], ott.id)
        position = position_service.process
        history_created, history = Histories::CreateHistory.new(@order, ott, @order.tecnic_id, arg[:photos], arg, "Mobile").process
       # @referral.destroy if history_created == false
       check = check + 1
      elsif thg
        ott = OutThing.create(customer_id: @order.customer_id,
                              thing: thg,
                              stock: 1)
        if ott
          @order.out_thing_id = ott.id
          @order.save
          position_service = Gps::GpsDataThing.new(arg[:latitude], arg[:longitude], ott.id)
          position = position_service.process
          history_created, history = Histories::CreateHistory.new(@order, ott, @order.tecnic_id, arg[:photos], arg, "Mobile").process
          check = check + 1
        end
      else
        thing = Thing.create(status_id: 300,
                             # order_id: @order.id,
                             name: arg[:name],
                             description: arg[:description],
                             code_scan: arg[:code_scan],
                             comments: EnsureUtf8Encode.new(arg[:comments]).process,
                             subsidiary_id: @subsidiary_id,
                             stock: 0
                             # user_id: @order.customer_id
                           )
        # thing.order_ids << @order.id
        if thing.save!
          out_thing = OutThing.new
          out_thing.thing = thing
          out_thing.customer_id = @order.customer_id
          out_thing.stock = 1
          if out_thing.save
            position_service = Gps::GpsDataThing.new(arg[:latitude], arg[:longitude], out_thing.id)
            position = position_service.process
            history_created, history = Histories::CreateHistory.new(@order, out_thing, @order.tecnic_id, arg[:photos], arg, "Mobile").process
            @order.things_ids << thing.id
            @order.out_thing_id = out_thing.id
            @order.save
            check = check + 1
          end
          # If thing is not saved destroy the referral
#          @referral.destroy if history_created == false
#        else
          # If thing is not saved destroy the referral
#          @referral.destroy
        end
      end
    end
    if cont = check
      return true
    else
      return false
    end
  end

end
