class AdminMailer < ApplicationMailer

  def welcome_mail(user, pass)
    @user = user
    @pass = pass
    @corporation = Corporation.find(@user.corporation_id)

    mail(to: @user.email, subject: "#{t('mailers.admin.welcome')}")
  end

end
