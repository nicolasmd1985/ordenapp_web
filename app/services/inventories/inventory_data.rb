class Inventories::InventoryData

  def initialize(inventory, things, subsidiary_id)
    @inventory = inventory
    @args_things = things
    @subsidiary_id = subsidiary_id
  end

  def process
    cont = @args_things.length
    check = 0
    @args_things.each do |arg|
      arg[:photos] = JSON.parse(arg[:photos]) unless arg[:photos].nil?

      exists_thing = Thing.where({code_scan: arg[:code_scan], subsidiary_id: @subsidiary_id}).first
      if exists_thing
        exists_thing.update_attribute(:stock, (exists_thing.stock.nil? ? arg[:stock].to_i : (exists_thing.stock + arg[:stock].to_i)))
        check = check + 1
      else
        thing = Thing.create(status_id: 300,
                             name: arg[:name],
                             description: arg[:description],
                             code_scan: arg[:code_scan],
                             subsidiary_id: @subsidiary_id,
                             category_id: arg[:category_id],
                             substatus_id: arg[:substatus_id],
                             final_price: arg[:final_price],
                             cost_price: arg[:cost_price],
                             stock: arg[:stock],
                             weight: arg[:weight],
                             unit_weight: arg[:unit_weight],
                             serial_number: arg[:serial_number],
                             start_warranty: arg[:start_warranty],
                             finish_warranty: arg[:finish_warranty],
                             start_time: arg[:start_time],
                             photos: arg[:photos]
                             # urlavatar: nil
                           )
        if thing.save!
          position_service = Gps::GpsDataThing.new(arg[:latitude], arg[:longitude], thing.id)
          position = position_service.process
          thing.position_ids << position.id if position
          thing.save
          check = check + 1
        end
      end
    end
    if cont = check
      return true
    else
      return false
    end




    # referral = Referral.create(comment: EnsureUtf8Encode.new(@args_referral[:comment]).process,
    #                            signature: @args_referral[:signature].delete("\n"),
    #                            full_name: EnsureUtf8Encode.new(@args_referral[:full_name]).process,
    #                            final_time: @args_referral[:final_time],
    #                            email: EnsureUtf8Encode.new(@args_referral[:email]).process,
    #                            order_id: @order)
    # if referral.save
    #   return referral, true
    # else
    #   return referral, false
    # end
  end

end
