class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :supervisor?

  def index
    @resquest_orders = Order.resquest_orders(current_user.subsidiary_id)
    @tecnics = User.includes(:status, :positions).where(["users.role = 0 AND users.subsidiary_id = #{current_user.subsidiary_id} AND users.active = true"])
  end

end
