class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:index, :demo_request]
  
  layout 'page'

  def index
    
  end

  def demo_request
    ApplicationMailer.demo_request_mail(params[:name],params[:email], params[:phone],true).deliver_now
    redirect_to root_url, notice: "sendDemoRequest"
  end
end
