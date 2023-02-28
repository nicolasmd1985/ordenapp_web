class Customers::ThingsController < ApplicationController
  before_action :authenticate_user!
  before_action :customer?

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to customers_dashboard_url, notice: "Devise not found"
  end

  def index
    if (params[:search].present? && !params[:search].blank?) || (params[:status].present? && !params[:status].blank?)
      @things = Thing.customer_search(current_user.id, params[:search], params[:status])
    else
      @things = Thing.customer_list(current_user.id)
    end
    @status = params[:status].present? ? params[:status] : ''
    add_breadcrumb "#{t("base.bar_menu.things.things")}"

  end

end
