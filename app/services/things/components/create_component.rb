class Things::Components::CreateComponent

  def initialize(params, thing, subsidiary_id)
    @params = params
    @thing = thing
    @subsidiary_id = subsidiary_id
  end

  def process
    @component = Things::Component.new
    @component.name = @params[:name].capitalize
    @component.description = @params[:description].capitalize
    @component.code_scan = @params[:code_scan]
    @component.thing_id = @thing.id
    @component.subsidiary_id = @subsidiary_id
    
    success = @component.save

    if success
      @component.update(code_scan: @component.slug) if @component.code_scan.blank?
      [success, @component]
    else
      success = false
      [success, @component]
    end
  end

end
