class Orders::Rates::UpdateRate

  def initialize(order_rate, params)
    @order_rate = order_rate
    @params = params
  end

  def process
    @order_rate.answer_1 = (@params[:answer_1].to_i == 0) ? 5 : permited_value(@params[:answer_1])
    @order_rate.answer_2 = (@params[:answer_2].to_i == 0) ? 5 : permited_value(@params[:answer_2])
    @order_rate.answer_3 = permited_value(@params[:answer_3])
    @order_rate.answer_4 = permited_value(@params[:answer_4])
    @order_rate.answer_5 = permited_value(@params[:answer_5])

    if @order_rate.save
      answered(@order_rate)
      success = true
      [success, @order_rate]
    else
      success = false
      [success, @order_rate]
    end
  end

  private
    def answered(order_rate)
      order_rate.update(year: order_rate.updated_at.strftime("%Y").to_i,
                                    month: order_rate.updated_at.strftime("%m").to_i,
                                    active: false)
    end

    def permited_value(value)
      permited_values = [0,1,2,3,4,5]
      if permited_values.include?(value.to_i)
        return value.to_i
      else
        return permited_values[5]
      end
    end

end
