class Users::CreateCity
  def initialize(name, place_id, country_id)
    @name = name
    @place_id = place_id
    @country_id = country_id
  end

  def create
    if City.find_by(place_id: @place_id).present?
      cityId = City.find_by(place_id: @place_id).id
      return cityId
    else
      city_name = @name.split(",")
      city_name.delete_at(city_name.length-1)
      if Country.find_by(place_id: @country_id).present?
        country_id = Country.find_by(place_id: @country_id).id
        cityId = City.create(country_id: country_id, name: city_name.join(","), place_id: @place_id).id
        return cityId
      else
        country_data = Net::HTTP.get(URI.parse("https://maps.googleapis.com/maps/api/place/details/json?placeid=#{@country_id}&key=#{ENV['GOOGLE_MAPS_API_SERVER_KEY']}"))
        country_data = JSON.parse country_data
        country_long_name = country_data["result"]["address_components"][0]["long_name"]
        country_short_name = country_data["result"]["address_components"][0]["short_name"]
        country_id = Country.create(name: country_long_name, country_code: country_short_name, place_id: @country_id).id
        cityId = City.create(country_id: country_id, name: city_name.join(","), place_id: @place_id).id
        return cityId
      end
    end
  end

end
