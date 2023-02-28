# if params[:referral].present?
#   referral_service = Referrals::ReferralData.new(params[:referral].values[0], params[:order])
#   referral, ch_referral = referral_service.process
#   if ch_referral
#     if params[:things].present?
#       things_service = Things::ThingsData.new(params[:things].values, params[:order], current_user.subsidiary_id, referral)
#       thing = things_service.process
#       if thing
#         @order = Order.finish(params[:order])
#         log_created, log = Orders::CreateOrderLog.new(@order, "finish", current_user, @order.saved_changes).process if @order.saved_changes?
#         order_rate_created, @order_rate = Orders::Rates::CreateRate.new(@order).process
#         if order_rate_created
#           OrderMailer.order_finished(@order)
#         end
#         return render json: { referral: "ok" }, status: :ok
#         OrderMailer.referral_mail(params[:order]).deliver_later
#       else
#         # destroy the referral if thing is false and referral exists
#         referral.destroy if referral
#         render json: { referral: "not saved" }, status: :unprocessable_entity
#       end
#     end
#     @order = Order.finish(params[:order]) #ENVIAR EL ID DE LA THING PARA ASOCIARLA CON LA ORDEN EJECUTADA
#     log_created, log = Orders::CreateOrderLog.new(@order, "finish", current_user, @order.saved_changes).process if @order.saved_changes?
#     order_rate_created, @order_rate = Orders::Rates::CreateRate.new(@order).process
#     if order_rate_created
#       OrderMailer.order_finished(@order)
#     end
#     return render json: { referral: "ok" }, status: :ok
#     OrderMailer.referral_mail(params[:order]).deliver_later
#   else
#     referral.destroy
#     render json: { referral: "not saved" }, status: :unprocessable_entity
#   end
