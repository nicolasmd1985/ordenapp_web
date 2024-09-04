class Users::CreateCity
  def initialize(city_value, place_id, country_id)
    @city_value = city_value
    @place_id = place_id
    @country_id = country_id
  end

  def create
    return nil if @city_value.blank? && @place_id.blank? && @country_id.blank?

    existing_city = City.find_by(place_id: @place_id)
    return existing_city if existing_city.present?

    city_name = @city_value.split(",")
    city_name.delete_at(-1)
    city_name = city_name.join(",")

    country = find_or_create_country
    return nil unless country

    City.create(country_id: country.id, name: city_name, place_id: @place_id)
  end

  private

  def find_or_create_country
    existing_country = Country.find_by(place_id: @country_id)
    return existing_country if existing_country.present?

    country_data = fetch_country_data
    return nil unless country_data

    Country.create(
      name: country_data["long_name"],
      country_code: country_data["short_name"],
      place_id: @country_id
    )
  end

  def fetch_country_data
    uri = URI.parse("https://maps.googleapis.com/maps/api/place/details/json?placeid=#{@country_id}&key=#{ENV['GOOGLE_MAPS_API_SERVER_KEY']}")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    if data["status"] == "OK"
      data["result"]["address_components"][0]
    else
      Rails.logger.error("Failed to fetch country data: #{data['status']}")
      nil
    end
  rescue StandardError => e
    Rails.logger.error("Error fetching country data: #{e.message}")
    nil
  end
end