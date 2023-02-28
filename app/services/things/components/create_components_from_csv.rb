class Things::Components::CreateComponentsFromCsv
  require 'csv'

  def initialize(csv_file, thing, subsidiary_id)
    @csv_file = csv_file
    @thing = thing
    @subsidiary_id = subsidiary_id
  end

  def process
    components_count = 0

    csv_text = File.read(@csv_file.path)
    csv = CSV.parse(csv_text, headers: true, col_sep: ',')

    csv.each do |component_array|
      name                = component_array[0]
      description         = component_array[1]
      code_scan           = component_array[2]
      subsidiary_id       = @subsidiary_id

      params = {}
      params[:name]               = name.blank? ? "NA" : name
      params[:description]        = description.blank? ? "NA" : description
      params[:code_scan]          = code_scan
      params[:subsidiary_id]      = subsidiary_id.to_i

      # clear code_scan field and verify if exist, if exist code_scan will be null
      params[:code_scan].delete!("\t") if !params[:code_scan].blank?
      check_code = Things::Component.find_by(code_scan: params[:code_scan])
      params[:code_scan] = nil if check_code

      component_created, component = Things::Components::CreateComponent.new(params, @thing, params[:subsidiary_id]).process

      components_count += 1
    end

    components_count
  end

end
