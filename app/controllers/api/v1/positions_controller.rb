class Api::V1::PositionsController < ApiController
	before_action :authorize_request

  def send_gps
    @position = Position.new(position_params)
		@position.user_id = @current_user.id
    if @position.save
      render json: @position, status: :created
    else
			render json: { errors: @position.errors.full_messages },
             status: :unprocessable_entity
    end
  end

	def absence
		position = Position.new(position_params)
		position.user_id = current_user.id

		if @position.save
			user = current_user
			user.update_attributes(status_id: 208) #Absence
			Gps::CreatePositionLog.new(user, position).process

			render json: {message: "Mark as #{user.status.description}"}, status: :ok
		else
			render json: {errors: @position.errors.full_messages}, status: :unprocessable_entity
		end
	end

	def index
		@positions = Position.where(user_id: current_user.id)
		render json: @positions, status: :ok
	end

	  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      params.permit(:latitude, :longitude)
    end

	end
