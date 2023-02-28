class Gps::GpsDataThing
  def initialize(latitude, longitude, out_thing)
    @latitude = latitude
    @longitude = longitude
    @out_thing = out_thing
  end

  def process
    position = Position.create({
      latitude:                 @latitude,
      longitude:                @longitude,
      out_thing_id:             @out_thing
      })
    if position.save
      return position;
    else
      return false;
    end
  end

end
