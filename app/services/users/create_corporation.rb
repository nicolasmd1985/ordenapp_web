class Users::CreateCorporation
  def initialize(params, status = 100)
    @params = params
    @status = status
  end

  def process
    create_corporation = Corporation.new
    create_corporation.name = @params[:corporation_id]
    create_corporation.phone = @params[:phone_number_1]
    create_corporation.email = @params[:email]
    create_corporation.status_id = @status
    if create_corporation.save
      Corporation.last.id
    else
      return false
    end
  end

end
