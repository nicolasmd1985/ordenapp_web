class Substatuses::UpdateSubstatus

  def initialize(params, substatus)
    @params = params
    @substatus = substatus
  end

  def process
    @substatus.description = @params[:description].capitalize
    @substatus.status_id = @params[:status_id].to_i

    success = @substatus.save

    [success, @substatus]
  end

end
