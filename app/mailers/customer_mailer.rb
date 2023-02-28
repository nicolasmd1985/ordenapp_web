class CustomerMailer < ApplicationMailer

  def welcome_mail(user, password_tem)
    @user = user
    if @user.email?
      @password_tem = password_tem
      @subsidiary = Subsidiary.find(@user.subsidiary_id)
      @token = set_reset_password_token(@user)
      mail(to: @user.email, subject: "Welcome #{@user.first_name} #{@user.last_name} to #{@subsidiary.name}")
    end
  end

  protected

  def set_reset_password_token(user)
    @user = user
    raw, enc = Devise.token_generator.generate(@user.class, :reset_password_token)
    @user.reset_password_token   = enc
    @user.reset_password_sent_at = Time.now.utc
    @user.save(validate: false)
    raw
  end

end
