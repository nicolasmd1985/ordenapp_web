class Admins::SubsidiariesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin?
  before_action :set_subsidiary, only: [:show, :edit, :update, :active]

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to admins_subsidiaries_url, notice: "Subsidiary not found"
  end

  def index
    @subsidiaries = Subsidiary.includes(:status).where(corporation_id: current_user.try(:corporation_id))
    add_breadcrumb "#{t("base.bar_menu.admins.subsidiaries")}/#{t("base.bar_menu.admins.list")}"
  end

  def new
    @subsidiary = Subsidiary.new
    add_breadcrumb "#{t("base.bar_menu.admins.subsidiaries")}/#{t("base.bar_menu.admins.new")}"
  end

  def create
    @subsidiary = Subsidiary.new(subsidiary_params)
    @subsidiary.status_id = 100
    @subsidiary.corporation_id = current_user.corporation_id

    if @subsidiary.save
      redirect_to admins_subsidiaries_path, notice: "#{@subsidiary.name} created successfully."
    else
      render :new
    end
  end

  def show
    @users = User.where(subsidiary_id: @subsidiary.id).count
    @supervisors = User.where(subsidiary_id: @subsidiary.id, role: 1).count
    @tecnics = User.where(subsidiary_id: @subsidiary.id, role: 0).count
    @customers = User.where(subsidiary_id: @subsidiary.id, role: 2).count

    @orders = Order.where(subsidiary_id: @subsidiary.id).count
    @requests = Order.where(subsidiary_id: @subsidiary.id, status_id: 500).count
    @assigneds = Order.where(subsidiary_id: @subsidiary.id, status_id: 501).count
    @progress = Order.where(subsidiary_id: @subsidiary.id, status_id: 502).count
    @rejecteds = Order.where(subsidiary_id: @subsidiary.id, status_id: 503).count
    @done = Order.where(subsidiary_id: @subsidiary.id, status_id: 504).count
    @pre_requests = Order.where(subsidiary_id: @subsidiary.id, status_id: 505).count

    @things = Thing.where(subsidiary_id: @subsidiary.id).count
    @actives = Thing.where(subsidiary_id: @subsidiary.id, status_id: 300).count
    @inactives = Thing.where(subsidiary_id: @subsidiary.id, status_id: 301).count
    @stock = Thing.where(subsidiary_id: @subsidiary.id, status_id: 302).count
    @installeds = Thing.where(subsidiary_id: @subsidiary.id, status_id: 303).count
    @installing = Thing.where(subsidiary_id: @subsidiary.id, status_id: 304).count
    @replacement = Thing.where(subsidiary_id: @subsidiary.id, status_id: 305).count
    @on_the_way = Thing.where(subsidiary_id: @subsidiary.id, status_id: 306).count
    @corrective = Thing.where(subsidiary_id: @subsidiary.id, status_id: 307).count
    @preventive = Thing.where(subsidiary_id: @subsidiary.id, status_id: 308).count
  end

  def edit
    if current_user.try(:corporation_id) == @subsidiary.corporation_id
      @editable = true
    else
      redirect_to admins_subsidiaries_path, notice:'This subsidiary not exists.'
    end
  end

  def update
    if @subsidiary.update(subsidiary_params)
      redirect_to admins_subsidiaries_path, notice: 'Subsidiary was successfully updated.'
    else
      render :edit
    end
  end

  def active
    if @subsidiary.status_id == 100
      @subsidiary.status_id = 101
    else
      @subsidiary.status_id = 100
    end
    if @subsidiary.save
      redirect_to admins_subsidiaries_url, notice: "Subsidiary #{@subsidiary.try(:name)} #{(@subsidiary.status_id == 100) ? "Actived." : "Inactived."}"
    else
      redirect_to admins_subsidiaries_url, alert: "An error has ocurred."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subsidiary
      @subsidiary = Subsidiary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def subsidiary_params
      params.permit(:document_type, :name, :phone, :address, :email, :identification, :subsidiary_initials, :status_id, :urlavatar)
    end
end
