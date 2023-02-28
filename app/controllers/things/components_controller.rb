class Things::ComponentsController < ApplicationController
  require 'csv'
  
  before_action :authenticate_user!
  before_action :supervisor?
  before_action :set_component, only: [:edit, :update, :destroy]
  before_action :set_thing, only: [:import_csv_form, :import_csv, :download_csv, :new, :create]

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to dashboard_url, notice: "Component not found"
  end

  def edit
  end

  def new
    @component = Things::Component.new
  end

  def update
    check_code = @component.validate_code_scan(params[:code_scan], current_user.subsidiary_id, @component)
    if check_code
      redirect_to edit_component_url(@component.slug), alert: 'Code scan must be unique.'
      return
    end

    component_updated, component = Things::Components::UpdateComponent.new(params, @component).process

    if component_updated
      redirect_to thing_url(@component.thing.slug), notice: "Component #{@component.name} was updated successfully."
    else
      render :edit
    end
  end

  def create
    @component = Things::Component.new
    check_code = @component.validate_code_scan(params[:code_scan], current_user.subsidiary_id, @component)

    if check_code
      redirect_to new_things_component_url, alert: 'Code scan must be unique.'
      return
    end

    component_created, @component = Things::Components::CreateComponent.new(params, @thing, current_user.subsidiary_id).process

    if component_created
      redirect_to thing_url(@component.thing.slug), notice: "Component #{@component.name} was successfully created."
    else
      render :new
    end
  end

  def import_csv_form
  end

  def import_csv
    csv_file = params[:csv_file]

    if csv_file.present? && File.extname(csv_file.original_filename) == ".csv"
      components_loaded = Things::Components::CreateComponentsFromCSV.new(csv_file, @thing, current_user.subsidiary_id).process

      redirect_to thing_url(@thing.slug), notice: "Se cargaron #{components_loaded} componentes"
    else
      redirect_to components_import_csv_form_url, alert: "An error has ocurred. Verify file extention."
    end
  end

  def download_csv
    layout =  CSV.generate do |csv|
                csv << ["name", "description", "code_scan"]
              end
    respond_to do |format|
      format.csv { send_data layout, filename: "upload components #{@thing.name} #{Date.today}.csv" }
    end
  end

  def destroy
    @component.destroy
    redirect_to things_components_url, notice: "Component #{@component.name} deleted."
  end


  def qr_code
    
    @data = params[:slug]

    label = Zebra::Zpl::Label.new(
      width:        350,
      length:       250,
      print_speed:  3
    )

    qrcode = Zebra::Zpl::Qrcode.new(
      data:             @data,
      position:         [50,10],
      scale_factor:     3,
      correction_level: 'H'
    )

    label << qrcode
    


    print_job = Zebra::PrintJob.new 'PDF_Printer'
    
    
    ip = 'localhost'
    print_job.print label, ip
    
    # print_job.print label, 'localhost', '127.0.0.1'
  end

  private
    def set_component
      @component = Things::Component.find_by(slug: params[:slug])
    end

    def set_thing
      @thing = Thing.find_by(slug: params[:slug])
    end

end
