class QrGeneratorController < ApplicationController
  require 'rqrcode'
  before_action :authenticate_user!
  before_action :supervisor?

  def index
    add_breadcrumb "#{t("base.bar_menu.things.things")}/#{t("qr.generator")}"
  end

  def company_qr_codes
    data = []
    @qr_codes = []

    if params[:obj_class].present? && !params[:obj_class].blank?
      obj_class =  obj_class_type(params[:obj_class])

      params[:quantity].to_i.times do
        name = generate_slug(obj_class)
        code_generated = {code_scan: "#{current_user.subsidiary.name} #{params[:obj_class]}-#{name}",
                          name: name}
        data << code_generated
      end

      data.each do |d|
        qrcode = RQRCode::QRCode.new(d[:code_scan], :size => 10, :level => :h)
        @svg = qrcode.as_svg(
          offset: 0,
          color: '000',
          shape_rendering: 'crispEdges',
          module_size: 4,
          standalone: true
        )
        @qr_codes << {img: @svg, name: d[:name]}
      end

      @qr_codes = @qr_codes.each_slice(4).to_a
      respond_to do |format|
        format.html
        format.pdf{render template: 'things/qr_code', pdf: "company_#{params[:obj_class]}_qr_codes", viewport_size: '1280x1024'}
      end
    else
      render :index
    end
  end

  private
    def obj_class_type(obj_class)
      case obj_class
      when "Tool"
        obj_class = Tool.new
      when "Thing"
        obj_class = Thing.new
      when "Component"
        obj_class = Things::Component.new
      end
    end

  protected
    def generate_slug(obj_class)
      begin
        code_scan = SecureRandom.hex
      end while obj_class.class.exists?(code_scan: code_scan)

      return code_scan if !code_scan.blank?
    end

end
