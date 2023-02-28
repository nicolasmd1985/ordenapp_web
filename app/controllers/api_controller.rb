class ApiController < ActionController::API
	include ActionController::RequestForgeryProtection
  protect_from_forgery unless: -> { request.format.json? }
	# protect_from_forgery prepend: true

	# before_action :authenticate
	# before_action :get_and_validate_token

	def not_found
		render json: { error: 'not_found' }
	end

	def authorize_request
		header = request.headers['Authorization']
		header = header.split(' ').last if header
		begin
		 @decoded = JsonWebToken.decode(header)
		 @current_user = User.find(@decoded[:user_id])
		rescue ActiveRecord::RecordNotFound => e
		 render json: { errors: e.message }, status: :unauthorized
		rescue JWT::DecodeError => e
		 render json: { errors: e.message }, status: :unauthorized
 		end
	end




end
