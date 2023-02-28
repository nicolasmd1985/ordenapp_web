class ApplicationMailer < ActionMailer::Base
  # add_template_helper(EmailHelper)
  default from: 'Ordenapp <contacto@ordenapp.co>'
  layout 'mailer'

  def demo_request_mail(name, email, phone ,accept_terms )
    @name = name
    @email = email
    @phone = phone
    @accept_terms = accept_terms
    mail(to: 'Mercadeo <mercadeo@ordenapp.co>', from:'Ordenapp <contacto@ordenapp.co>', subject: "#{@name} is requesting a demo")
  end
end
