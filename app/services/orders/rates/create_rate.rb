class Orders::Rates::CreateRate

  def initialize(order)
    @order = order
  end

  def process
    question_1 = "¿Cómo calificaría la atención que tuvo el personal que lo atendió?"
    question_2 = "¿Cómo le pareció el servicio?"
    question_3 = "¿El personal que lo atendió fue ordenado y dejo limpio el lugar?"
    question_4 = "¿El personal que lo atendió dejo instrucciones adecuadas de uso?"
    question_5 = "¿Se dejo calcomania de identificación en los items?"

    @order_rate = OrderRate.new
    @order_rate.order_id = @order.id
    @order_rate.user_id = @order.customer_id
    @order_rate.subsidiary_id = @order.subsidiary_id
    @order_rate.question_1 = question_1
    @order_rate.question_2 = question_2
    @order_rate.question_3 = question_3
    @order_rate.question_4 = question_4
    @order_rate.question_5 = question_5

    success = @order_rate.save

    if success
      [success, @order_rate]
    else
      success = false
      [success, false]
    end
  end

end
