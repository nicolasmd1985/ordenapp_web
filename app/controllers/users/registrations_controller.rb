# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include ActionView::Helpers::SanitizeHelper

  skip_before_action :require_no_authentication, only: [:create, :complete]
  before_action :configure_edit_user_params, if: :devise_controller?, only: [:edit, :update] 
  before_action :rate_limit, only: [:create]
  before_action :require_no_authentication, only: [:new, :create, :cancel]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]

  layout 'page', only: [:new, :complete]

  def new
    super
  end

  def create
    if valid_registration_attempt?
      create_user
    else
      handle_invalid_registration
    end
  end

  def edit
    super
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(resource, account_update_params)
      handle_successful_update(prev_unconfirmed_email)
    else
      handle_failed_update
    end
  end

  def destroy
    super
  end

  def cancel
    super
  end

  def complete
    build_resource({})
    yield resource if block_given?
    @auth = session["omniauth.data"]
    @user.first_name = sanitize(@auth["info"]["first_name"])
    @user.last_name = sanitize(@auth["info"]["last_name"])
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:corporation_id, :subsidiary_id, :role, :first_name, :last_name, :document_number, :document_type, :phone_number_1, :status_id, :active, :city_id, :principal_activity, :provider, :uid])
  end

  def configure_edit_user_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:web_page, :priority_user, :principal_activity, :company_name, :document_type, :document_number, :first_name, :last_name, :email, :phone_number_1, :phone_number_2, :address_1, :address_2, :corporation_id, :subsidiary_id, :role, :status_id, :active, :city_id, :urlavatar])
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  def after_inactive_sign_up_path_for(resource)
    root_path
  end

  private


  def valid_registration_attempt?
    params[:user][:accept_terms] == '1' && !bot_detected? && verify_recaptcha(action: 'signup', minimum_score: 0.5, secret_key: ENV['RECAPTCHA_SECRET_KEY'])
  end

  def create_user
    if user_signed_in? && params[:user][:role].present?
      create_authenticated_user
    elsif session["omniauth.data"].nil?
      create_regular_user
    else
      create_omniauth_user
    end
  end

  def create_authenticated_user
    @user = User.new(user_params)
    @user.assign_attributes(
      role: params[:role].to_i,
      password: Users::PasswordGenerator.generate,
      active: false,
      first_name: @user.first_name&.capitalize,
      last_name: @user.last_name&.capitalize,
      subsidiary_id: current_user.role == 'supervisor' ? current_user.subsidiary_id : nil,
      corporation_id: current_user.corporation_id,
      status_id: 200,
      city_id: create_city.id
    )

    if @user.save
      UserMailer.verification_email(@user).deliver_later
      log_successful_registration(@user)
      redirect_to root_path, notice: 'Please check your email to verify your account.'
    else
      log_failed_registration(@user)
      render :new
    end
  end

  def create_regular_user
    check_mail = User.find_by(email: params[:user][:email])
    check_corporation = Corporation.find_by(name: params[:user][:corporation_id])

    if check_corporation.nil? && check_mail.nil?
      corporation = Users::CreateCorporation.new(params[:user])
      corporation_id = corporation.process

      if corporation_id
        create_corporation_user(corporation_id)
      else
        error_create(check_mail, check_corporation)
      end
    else
      error_create(check_mail, check_corporation)
    end
  end

  def create_corporation_user(corporation_id)
    @user = User.new(user_params)
    @user.assign_attributes(
      corporation_id: corporation_id,
      role: 3,
      status_id: 200,
      active: false,
      document_type: "OTRO"
    )

    if params[:user][:accept_terms] == '1' && @user.save
      AdminMailer.welcome_mail(@user, @user.password).deliver_later
      sign_in(@user)
      redirect_to after_sign_up_path_for(@user), notice: 'Account created successfully. Please check your email for further instructions.'
    else
      @user.errors.add(:accept_terms, "must be accepted") unless params[:user][:accept_terms] == '1'
      log_failed_registration(@user)
      render :new
    end
  end

  def create_omniauth_user
    @auth = session["omniauth.data"]
    params[:user][:email] = @auth["info"]["email"]
    check_mail = User.find_by(email: params[:user][:email])
    check_corporation = Corporation.find_by(name: params[:user][:corporation_id])

    if check_corporation.nil? && check_mail.nil?
      corporation = Users::CreateCorporation.new(params[:user])
      corporation_id = corporation.process

      if corporation_id
        create_omniauth_corporation_user(corporation_id)
      else
        error_create(check_mail, check_corporation)
      end
    else
      error_create(check_mail, check_corporation)
    end
  end
  
  def create_omniauth_corporation_user(corporation_id)
    name_array = @auth["info"]["name"].split(/ /, 2)
    @user = User.new(user_params.merge(
      first_name: name_array[0],
      last_name: name_array[1],
      password: Devise.friendly_token[0,20],
      provider: @auth["provider"],
      uid: @auth["uid"],
      corporation_id: corporation_id,
      role: 3,
      status_id: 200,
      active: false,
      document_type: "OTRO"
    ))

    if @user.save
      AdminMailer.welcome_mail(@user, @user.password).deliver_later
      sign_in(@user)
      redirect_to after_sign_up_path_for(@user), notice: 'Account created successfully. Please check your email for further instructions.'
    else
      log_failed_registration(@user)
      render :new
    end
  end

  def handle_invalid_registration
    log_potential_bot_attempt
    flash.now[:alert] = 'Registration attempt failed. Please try again.'
    @user = User.new(user_params)
    @user.errors.add(:accept_terms, "must be accepted") unless params[:user][:accept_terms] == '1'
    render :new
  end

  def handle_successful_update(prev_unconfirmed_email)
    if sign_in_after_change_password?
      bypass_sign_in resource, scope: resource_name
    end

    respond_to do |format|
      format.html { redirect_to after_update_path_for(resource), notice: "Account updated successfully." }
      format.json { render :show, status: :ok, location: resource }
    end
  end

  def handle_failed_update
    clean_up_passwords resource
    set_minimum_password_length
    respond_to do |format|
      format.html { render :edit }
      format.json { render json: resource.errors, status: :unprocessable_entity }
    end
  end

  def error_create(check_mail, check_corporation)
    msg_email = check_mail ? "El correo electrónico \"#{check_mail.email}\" ya se encuentra registrado." : nil
    msg_corporation = check_corporation ? "La compañía \"#{check_corporation.name}\" ya se encuentra registrada." : nil
    redirect_to new_user_registration_url, alert: [msg_email, msg_corporation].compact.join(' ')
  end

  def bot_detected?
    params[:user][:honeypot].present?
  end

  def user_params
    params.require(:user).permit(
      :email, :first_name, :last_name, :role, :web_page, :priority_user,
      :principal_activity, :company_name, :document_type, :document_number,
      :phone_number_1, :phone_number_2, :address_1, :address_2, :subsidiary_id,
      :urlavatar, :password, :password_confirmation
    )
  end

  def create_city
    Users::CreateCity.new(params[:user][:city_value], 
                          params[:user][:place_id], 
                          params[:user][:country_id]).create
  end

  def rate_limit
    key = "registration_count:#{request.remote_ip}"
    count = Rails.cache.read(key).to_i

    if count > 5
      render json: { error: 'Too many registration attempts' }, status: :too_many_requests
    else
      Rails.cache.write(key, count + 1, expires_in: 1.hour)
    end
  end

  def log_successful_registration(user)
    Rails.logger.info("Successful registration: #{user.email} from IP #{request.remote_ip}")
  end

  def log_failed_registration(user)
    Rails.logger.warn("Failed registration attempt: #{user.email} from IP #{request.remote_ip}")
    Rails.logger.warn("Errors: #{user.errors.full_messages.join(', ')}")
  end

  def log_failed_registration(user)
    Rails.logger.warn("Failed registration attempt: #{user.email} from IP #{request.remote_ip}")
    Rails.logger.warn("Errors: #{user.errors.full_messages.join(', ')}")
  end
end