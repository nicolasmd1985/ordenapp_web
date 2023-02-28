class Admins::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin?

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to admins_users_url, notice: "User not found"
  end

  def index
    @users = User.includes(:subsidiary).where({corporation_id: current_user.corporation_id, role: 1})
    add_breadcrumb "#{t("base.bar_menu.admins.supervisor")}/#{t("base.bar_menu.admins.list")}"
  end

end
