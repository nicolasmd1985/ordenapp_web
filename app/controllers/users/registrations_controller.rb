# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.
  skip_before_action :require_no_authentication, only: [:create, :complete]
  before_action :configure_edit_user_params, if: :devise_controller?, only: [:edit, :update]
  layout 'page', only: [:new, :complete]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    if user_signed_in? && params[:user][:role].present? #&& params[:user][:email].present?
      @user.role = params[:role].to_i if params[:role]
      @user = User.new(user_params)
      password_tem = Users::PasswordGenerator.generate
      @user.password = password_tem
      @user.active = true
      @user.first_name = @user.first_name ? @user.first_name.capitalize : @user.first_name
      @user.last_name = @user.last_name ? @user.last_name.capitalize : @user.last_name
      @user.subsidiary_id = current_user.subsidiary_id if current_user.role == 'supervisor'
      @user.corporation_id = current_user.corporation_id
      @user.status_id = 200
      cityId = Users::CreateCity.new(params[:user][:city_value], params[:user][:place_id], params[:user][:country_id])
      @user.city_id = cityId.create
      if @user.save
        if params[:slug] == 'order' && params[:slug].present?
          CustomerMailer.welcome_mail(@user, password_tem).deliver_later
          render json: @user, status: :ok
        else
          case @user.role
          when 'supervisor'
            SupervisorMailer.welcome_mail(@user, password_tem).deliver_later
          when 'tecnic'
            TecnicMailer.welcome_mail(@user, password_tem).deliver_later
          when 'customer'
            CustomerMailer.welcome_mail(@user, password_tem).deliver_later
          end
          if current_user.role == 'admin'
            redirect_to @user, notice: 'User was successfully created.'
          else
            redirect_to @user, notice: 'User was successfully created.'
          end
        end
      else
        if params[:slug] == 'order' && params[:slug].present?
          render json: @user.errors, status: :unprocessable
        else
          render :new, template: "users/new"
        end
      end
    elsif session["omniauth.data"].nil?
      check_mail = User.find_by(email: params[:user][:email])
      check_corporation = Corporation.find_by(name: params[:user][:corporation_id])
      if check_corporation.nil? && check_mail.nil?
        corporation = Users::CreateCorporation.new params[:user]
        corporation_id = corporation.process
        if corporation_id
          params[:user][:corporation_id] = corporation_id
          params[:user][:role] = 3
          params[:user][:status_id] = 200
          params[:user][:active] = true
          params[:user][:document_type] = "OTRO"
          configure_sign_up_params
          super
          @user.save!(validate: false)
          # Se incluye el envio de mail bienvenida al admin que ha creado la Compañia
          AdminMailer.welcome_mail(@user, params[:user][:password]).deliver_later
        else
          msg_email = "El correo eléctronico \"#{check_mail.email}\" ya se encuentra registrado." if !check_mail.blank?
          msg_corporation = "La compañia \"#{check_corporation.name}\" ya se encuentra registrada." if !check_corporation.blank?
          redirect_to new_user_registration_url, alert:"#{msg_email} #{msg_corporation}"
        end
      else
        msg_email = "El correo eléctronico \"#{check_mail.email}\" ya se encuentra registrado." if !check_mail.blank?
        msg_corporation = "La compañia \"#{check_corporation.name}\" ya se encuentra registrada." if !check_corporation.blank?
        redirect_to new_user_registration_url, alert:"#{msg_email} #{msg_corporation}"
      end
    else
      @auth = session["omniauth.data"]
      params[:user][:email]= @auth["info"]["email"]
      check_mail = User.find_by(email: params[:user][:email])
      check_corporation = Corporation.find_by(name: params[:user][:corporation_id])
        if check_corporation.nil? && check_mail.nil?
          corporation = Users::CreateCorporation.new params[:user]
          corporation_id = corporation.process
          if corporation_id
            name_array = @auth["info"]["name"].split(/ /, 2)
            params[:user][:first_name] = name_array[0]
            params[:user][:last_name] = name_array[1]
            params[:user][:password] = Devise.friendly_token[0,20]
            params[:user][:provider] = @auth["provider"]
            params[:user][:uid]= @auth["uid"]
            params[:user][:corporation_id] = corporation_id
            params[:user][:role] = 3
            params[:user][:status_id] = 200
            params[:user][:active] = true
            params[:user][:document_type] = "OTRO"
            configure_sign_up_params
            super
            @user.save!(validate: false)
            # Se incluye el envio de mail bienvenida al admin que ha creado la Compañia
            AdminMailer.welcome_mail(@user, params[:user][:password]).deliver_later
          else
            error_create(check_mail, check_corporation)
          end
        else
          error_create(check_mail, check_corporation)
        end
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      flash.now[:notice] = "Tu cuenta ha sido actualizada con exíto."
      render :edit
    else
      clean_up_passwords resource
      set_minimum_password_length
      flash.now[:alert] = "Falló la actualización."
      render :edit
    end
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  def complete
    build_resource({})
    yield resource if block_given?
    @auth = session["omniauth.data"]
    name_array = @auth["info"]["name"].split(/ /, 2)
    @user.first_name = name_array[0]
    @user.last_name = name_array[1]
  end


  protected

  def error_create(check_mail, check_corporation)
    msg_email = "El correo eléctronico \"#{check_mail.email}\" ya se encuentra registrado." if !check_mail.blank?
    msg_corporation = "La compañia \"#{check_corporation.name}\" ya se encuentra registrada." if !check_corporation.blank?
    redirect_to new_user_registration_url, alert:"#{msg_email} #{msg_corporation}"
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:corporation_id, :subsidiary_id, :role, :first_name, :last_name, :document_number, :document_type, :phone_number_1, :status_id, :active, :city_id, :principal_activity, :provider, :uid])
  end

  def configure_edit_user_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:web_page, :priority_user, :principal_activity, :company_name, :document_type, :document_number, :first_name, :last_name, :email, :phone_number_1, :phone_number_2, :address_1, :address_2, :corporation_id, :subsidiary_id, :role, :status_id, :active, :city_id, :urlavatar])
  end

  def user_params
    params.require(:user).permit(:web_page, :priority_user, :principal_activity, :company_name, :document_type, :document_number, :first_name, :last_name, :email, :phone_number_1, :phone_number_2, :address_1, :address_2, :corporation_id, :subsidiary_id, :role, :status_id, :active, :city_id, :urlavatar)
  end

  private
    def check_captcha
      unless verify_recaptcha
        self.resource = User.new sign_up_params
        resource.validate # Look for any other validation errors besides reCAPTCHA
        set_minimum_password_length
        respond_with_navigational(resource) { redirect_to new_user_registration_url }
      end
    end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource) || dashboard_index_path
  # end
  #
  # # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource) || dashboard_index_path
  # end

  # def after_sign_up_path_for(resource)
  #   stored_location_for(resource) || dashboard_index_path
  # end
  #
  # def after_sign_in_path_for(resource)
  #   stored_location_for(resource) || dashboard_index_path
  # end
end
