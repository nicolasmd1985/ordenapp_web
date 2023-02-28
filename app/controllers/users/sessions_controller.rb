# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  layout 'page'

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    @user = User.find_by email: params[:user][:email]
    if @user # validate user existences
      if @user.corporation.status_id == 100
        if @user.role == 'admin'
          if @user.corporation.subsidiaries.count <= 0
            redirect_to edit_user_registration_url, notice: "Update your account to manage subsidiaries."
            return
          else
            redirect_to admins_subsidiaries_path, notice: t('devise.sessions.signed_in_admin')
            return
          end
        end
        if @user.subsidiary.status_id == 100 # validate subsidiary's status
          case @user.role
          when 'supervisor'
            redirect_to dashboard_path, notice: t('devise.sessions.signed_in_supervisor')
          when 'customer'
            redirect_to customers_dashboard_path, notice: t('devise.sessions.signed_in_customer')
          when 'tecnic'
            if @user.active # validate if tecnic and if is active or not
              redirect_to edit_user_registration_path, notice: t('devise.sessions.signed_in_tecnic')
            else
              user_inactive
            end
          end
        elsif @user.subsidiary.status_id == 101 && @user.role == "customer"
          redirect_to customers_dashboard_path, notice: t('devise.sessions.signed_in_customer')
        else
          subsidiary_inactived
        end
      elsif @user.corporation.status_id == 101 && @user.role == "customer"
        redirect_to customers_dashboard_path, notice: t('devise.sessions.signed_in_customer')
      else
        corporation_inactived
      end
    else
      redirect_to new_user_session_path, alert: t('devise.failure.invalid_email', email: params[:user][:email])
    end
  end

  def corporation_inactived
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :alert, :corporation_inactived if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  def subsidiary_inactived
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :alert, :subsidiary_inactived if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  def user_inactive
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :alert, :user_inactive if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
