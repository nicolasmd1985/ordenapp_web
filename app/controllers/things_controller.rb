class ThingsController < ApplicationController
  require 'rqrcode'
  before_action :authenticate_user!
  before_action :supervisor?
  before_action :set_thing, only: [:show, :edit, :update, :destroy, :qr_code]

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to dashboard_url, notice: "Devise not found"
  end

  def index
    if (params[:search].present? && !params[:search].blank?) || (params[:status].present? && !params[:status].blank?) || (params[:customer].present? && !params[:customer].blank?)
      @things = Thing.search(current_user.subsidiary_id, params[:search], params[:customer], params[:status])
      $things_qr = @things
    else
      @things = Thing.list(current_user.subsidiary_id)
      $things_qr  = @things
    end
    @status = params[:status].present? ? params[:status] : ''
    @customer = params[:customer].present? ? params[:customer] : ''
    add_breadcrumb "#{t("base.bar_menu.things.things")}/#{t("base.bar_menu.things.list")}"
  end

  def show

    if @thing.subsidiary_id == current_user.subsidiary_id
      @maintenance = Maintenance.new
    else
      redirect_to things_url, notice: "This Devise is not registered in your subsidiary"
    end
  end

  def new
    add_breadcrumb "#{t("base.bar_menu.things.things")}/#{t("base.bar_menu.things.new")}"
    @thing = Thing.new
  end


  def edit
    if @thing.subsidiary_id == current_user.subsidiary_id
    else
      redirect_to things_url, notice: "This Devise is not registered in your subsidiary"
    end
  end

  def create
    @thing = Thing.new(thing_params)
    @thing.subsidiary_id = current_user.subsidiary_id
    @thing.status_id = 300
    # @thing.category_id = Category.find_by(name: "Dispositivo").id if @thing.category_id.blank?
    check_code = @thing.validate_code_scan(params[:thing][:code_scan], current_user.subsidiary_id, @thing)

    if check_code
      redirect_to new_thing_url, alert: 'Code scan must be unique.'
      return
    end
    if @thing.save
      @thing.update_attributes(code_scan: @thing.slug) if @thing.code_scan.blank?
      # if @thing.maintenance_date
      #   if @thing.notification && (@thing.notification_time != "0")
      #     Things::SetNotification.new(@thing, 1).process
      #   else
      #     Things::SetNotification.new(@thing, 0).process
      #   end
      # end
      redirect_to thing_url(@thing.slug), notice: 'Thing was successfully created.'
    else
      render :new
    end

  end

  def update
    check_code = @thing.validate_code_scan(params[:thing][:code_scan], current_user.subsidiary_id, @thing)

    if check_code
      redirect_to edit_thing_url(@thing.slug), alert: 'Code scan must be unique.'
      return
    end

    # thing_updated, thing = Things::Update.new(@thing, params[:thing]).process
    # if @user.update(user_params)

    if @thing.update(thing_params)
      # if @thing.maintenance_date
      #   if @thing.notification && (@thing.notification_time != "0")
      #     Things::SetNotification.new(@thing, 1).process
      #   else
      #     Things::SetNotification.new(@thing, 0).process
      #   end
      # end
      redirect_to thing_url(@thing.slug), notice: t('things.index.updated_true')
    else
      redirect_to edit_thing_url(@thing.slug), alert: t('things.index.updated_false')
    end

  end

  def destroy
    @thing.destroy
    redirect_to things_url, notice: 'Thing was successfully destroyed.'
  end

  def qr_code

    if params[:slug].present?
      data = [@thing]
    else
      data =  $things_qr
    end

    @qr_codes = []

    data.each do |d|

      qrcode = RQRCode::QRCode.new(d.code_scan, :size => 10, :level => :h)

      @svg = qrcode.as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 4,
        standalone: true
      )

      @qr_codes << {img: @svg, name: d.name}

    end

    @qr_codes = @qr_codes.each_slice(4).to_a
    respond_to do |format|
      format.html
      format.json
      format.pdf{render template: 'things/qr_code', pdf: 'qr_codes', viewport_size: '1280x1024'}
    end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thing
      add_breadcrumb "#{t("base.bar_menu.things.things")}"
      @thing = Thing.find_by(slug: params[:slug])
      if params[:action] == 'update'
        @thing = Thing.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def thing_params
      params.require(:thing).permit(:status_id, :order_id, :name, :description, :code_scan, :subsidiary_id, :maintenance_date, :maintenance_time, :maintenance_frecuency_type, :maintenance_quantity, :user_id, :category_id, :substatus_id, :urlavatar,:finish_warranty, :start_warranty, :serial_number, :unit_weight, :weight, :stock, :cost_price, :final_price, :notification, :notification_time)
    end
end
