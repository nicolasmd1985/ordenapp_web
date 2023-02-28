class Substatuses::CreateSubstatus

  def initialize(params, current_user, category)
    @params = params
    @current_user = current_user
    @category = category
  end

  def process
    if @category == "thing"
      @substatus = Substatus.new
      @substatus.substatus_type = "things_status"
      @substatus.description = @params[:description].capitalize
      @substatus.status_id = @params[:status_id].to_i
      @substatus.subsidiary_id = @current_user.subsidiary_id
    else
      @substatus = Substatus.new
      @substatus.description = @params[:description].capitalize
      @substatus.status_id = @params[:status_id].to_i
      @substatus.subsidiary_id = @current_user.subsidiary_id
    end

    success = @substatus.save

    [success, @substatus]
  end

end
