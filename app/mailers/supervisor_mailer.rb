class SupervisorMailer < ApplicationMailer

  def welcome_mail(user, password_tem)
    @user = user
    @password_tem = password_tem
    @subsidiary = Subsidiary.find(@user.subsidiary_id)

    mail(to: @user.email, subject: "#{t('mailers.supervisor.welcome')} #{@subsidiary.name}  to Ordenapp")
  end


end
