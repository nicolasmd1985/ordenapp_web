class Gps::GpsDataUser
  def initialize(latitude, longitude, user_id)
    @latitude = latitude
    @longitude = longitude
    @user_id = user_id
  end

  def process
    position = Position.create({
      latitude:                 @latitude,
      longitude:                @longitude,
      user_id:                 @user_id
      })
    if position.save
      return position;
    else
      return false;
    end
  end

end
