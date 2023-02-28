class Api::V2::InventoriesController < ApiController
	before_action :authorize_request

  def get_data
		if params[:inventory].present?
			@params = params
			inventory_save = Inventories::InventoryData.new(@params[:inventory].values[0], @params[:things].values, params[:subsidiary_id]).process
			if inventory_save
				return render json: { inventory: "ok" }, status: :ok
			else
				render json: { inventory: "not saved" }, status: :unprocessable_entity
			end
		else
			render json: { inventory: "not saved" }, status: :unprocessable_entity
		end
  end

	def out_product
		if params.present?
			thing = Thing.find_by(code_scan: params[:code_scan], subsidiary_id: params[:subsidiary_id] )
			if params[:customer_id].to_i == 0
				ott = OutThing.new
				ott.thing = thing
				ott.stock = params[:quantity]
				if ott.save
					history_created, history = Histories::CreateHistory.new(nil, ott, current_user.id, nil, params, "Mobile").process
					if history_created
						thing.update_attribute(:stock, (thing.stock.to_i - params[:quantity].to_i) )
					else
						render json: { out_product: "not saved" }, status: :unprocessable_entity
					end
					render json: { out_product: "saved" }, status: :ok
				else
					render json: { out_product: "not saved" }, status: :unprocessable_entity
				end
			else
				ott = OutThing.where(thing: thing, customer_id: params[:customer_id]).first
				if ott
					history_created, history = Histories::CreateHistory.new(nil, ott, current_user.id, nil, params, "Mobile").process
					if history_created
						thing.update_attribute(:stock, (thing.stock.to_i - params[:quantity].to_i) )
						render json: { out_product: "saved" }, status: :ok
					else
						render json: { out_product: "not saved" }, status: :unprocessable_entity
					end
				else
					ott = OutThing.new
					ott.thing = thing
					ott.stock = params[:quantity]
					ott.customer_id = params[:customer_id]
					if ott.save
						history_created, history = Histories::CreateHistory.new(nil, ott, current_user.id, nil, params, "Mobile").process
						if history_created
							thing.update_attribute(:stock, (thing.stock.to_i - params[:quantity].to_i) )
							render json: { out_product: "saved" }, status: :ok
						else
							render json: { out_product: "not saved" }, status: :unprocessable_entity
						end
					else
						render json: { out_product: "not saved" }, status: :unprocessable_entity
					end
				end
			end
		end

	end




end
