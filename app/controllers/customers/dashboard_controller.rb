class Customers::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :customer?

  def index
    @orders = Order.customer_resquest_orders(current_user.subsidiary_id, current_user.id)
    @finished_orders = Order.customer_resquest_orders_finished(current_user.subsidiary_id, current_user.id)
  end

  def contact_company
    @company = Corporation.find(current_user.try(:corporation_id))
    @subsidiary = Subsidiary.find(current_user.try(:subsidiary_id))
  end

end
