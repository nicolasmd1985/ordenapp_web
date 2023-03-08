class Api::V2::AuthenticationController < ApiController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user.corporation.status_id != 100 || (@user.subsidiary.nil? ? false : @user.subsidiary.status_id != 100)
      render json: { error: 'Company or subsidiary inactive' }, status: :unauthorized
    else
      if @user.valid_password?(params[:password]) && ((@user.role == "supervisor" || @user.role == "admin") && @user.active == true)
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i
        @user.update_attribute(:token_message, params[:token_params]) if params[:token_params].present?
        @user.update(status_id: 202) #Available
        Gps::CreatePositionLog.new(@user).process

        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
          email: @user.email, user_id: @user.id,
          first_name: @user.first_name,
          last_name: @user.last_name,
          status_id: @user.status_id }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
