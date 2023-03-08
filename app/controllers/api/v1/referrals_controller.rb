class Api::V1::ReferralsController < ApiController
	before_action :authorize_request

  def get_data
		if params[:referral].present?
			@params = params
			referral, referral_saved = Referrals::ReferralData.new(@params[:referral].values[0], @params[:order]).process
			if referral_saved
				case params[:referral].values[0][:status_id]
				when "506"
					if params[:things].present?
						things_histories
					end
					status_define(506)
					return render json: { referral: "ok" }, status: :ok
				when "508"
					if params[:things].present?
						things_histories
					end
					status_define(508)
					return render json: { referral: "ok" }, status: :ok
				else
					if params[:things].present?
						things_histories
					end
					status_define(507)
					return render json: { referral: "ok" }, status: :ok
				end
			else
				render json: { referral: "Error while saving the referral." }, status: :unprocessable_entity
			end
		else
			render json: { referral: "not saved" }, status: :unprocessable_entity
		end
  end

	def status_define(status_id)
		user = current_user
		user.update(status_id: 202) #Available
		@order = Order.status_order(@params[:order], status_id)
		name_status = Status.find(status_id).description

		log_created, log = Orders::CreateOrderLog.new(@order, name_status, current_user, @order.saved_changes).process if @order.saved_changes?
		Gps::CreatePositionLog.new(user).process
		Notifications::CreateNotification.new(@order, current_user).process
	end

	def things_histories
		things_service = Things::GetData.new(@params[:things].values, @params[:order], current_user.subsidiary_id)
		thing = things_service.process
	end

end
