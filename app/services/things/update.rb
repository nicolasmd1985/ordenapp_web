class Things::Update

  def initialize(thing, params)
    @thing = thing
    @params = params
  end

  def process
    @thing.status_id = @params[:status_id]
    @thing.code_scan = @params[:code_scan].blank? ? @thing.slug : @params[:code_scan]
    @thing.name = @params[:name]
    @thing.description = @params[:description]
    @thing.category_id = @params[:category_id].blank? ? @thing.category_id : @params[:category_id]
    @thing.maintenance_date = @params[:maintenance_date]
    @thing.maintenance_frecuency_type = @params[:maintenance_frecuency_type]
    @thing.maintenance_quantity = @params[:maintenance_quantity]

    if @thing.user_id.present?
      if @thing.user_id == @params[:user_id].to_i
        success = @thing.save
        [success, @thing]

      else
        success = false
        [success, @thing]
      end
    else
      @thing.user_id = @params[:user_id]
      success = @thing.save
      [success, @thing]
    end

  end

end
