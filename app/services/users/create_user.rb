class Users::CreateUser

  def initialize(params, subsidiary_id)
    @params = params
    @subsidiary_id = subsidiary_id

  end

  def process

    @user = User.new
    password_tem = Users::PasswordGenerator.generate
    @user.password          = password_tem
    @user.document_number   = @params[:document_number]
    @user.first_name        = @params[:first_name].capitalize
    @user.last_name         = @params[:last_name].capitalize
    @user.phone_number_1      = @params[:phone_number_1]
    @user.email             = @params[:email]
    @user.document_type     = @params[:document_type]
    @user.company_name      = @params[:company_name]
    @user.principal_activity= @params[:principal_activity]
    @user.priority_user     = @params[:priority_user]
    @user.web_page          = @params[:web_page]
    @user.role              = @params[:role].to_i
    @user.city_id           = @params[:city_id]
    @user.subsidiary_id     = @params[:subsidiary_id]
    @user.corporation_id    = @params[:corporation_id]
    @user.active            = true
    @user.status_id         = 200

    if @user.save

      case @user.role
      when 'supervisor'
        SupervisorMailer.welcome_mail(@user, password_tem).deliver_later
      when 'tecnic'
        TecnicMailer.welcome_mail(@user, password_tem).deliver_later
      when 'customer'
        CustomerMailer.welcome_mail(@user, password_tem).deliver_later
      end
    end
  end
end        
