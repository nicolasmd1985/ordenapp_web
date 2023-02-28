class ThingNotifier < ApplicationMailer

  def thing_maintenance_notification(supervisor, orders = nil, thing)
    @user = supervisor
    @orders = orders
    @thing = thing
    mail(:to => @user.email, :subject => "Servicios programados")
  end

end
