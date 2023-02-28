class Things::Components::UpdateComponent

  def initialize(params, component)
    @params = params
    @component = component
  end

  def process
    @component.name = @params[:name].capitalize
    @component.code_scan = @params[:code_scan].blank? ? @component.slug : @params[:code_scan]
    @component.description = @params[:description].capitalize

    success = @component.save

    if success
      [success, @component]
    else
      success = false
      [success, @component]
    end
  end

end
