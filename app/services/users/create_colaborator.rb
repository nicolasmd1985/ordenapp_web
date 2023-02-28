class Users::CreateColaborator
  def initialize(params, subsidiary)
    @args = params
    @subsidiary =  subsidiary
  end

  def process
    user = User.create({
      first_name:               @args[:first_name],
      last_name:                @args[:last_name],
      email:                    @args[:email],
      phone_number_1:             @args[:phone_number_1],
      identification:           @args[:identification],
      role:                     0,
      password:                 'dipzo123',
      subsidiary_id:            @subsidiary
      })

    return user.save

  end

end
