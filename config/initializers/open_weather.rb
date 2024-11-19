class OpenWeatherAPI
  def initialize
    @api_key = ENV['SENDGRID_API_KEY']
  end

  def get_weather(city, state, country, from)
    place = get_coordinates(city, state, country)
    resp = JSON.parse(RestClient.get("https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=#{place[:lat]}&lon=#{place[:lon]}&dt=#{from.to_i}&units=metric&appid=#{@api_key}"))
    {
      main: resp['data'][0]['weather'][0]['main'],
      description: resp['data'][0]['weather'][0]['description'],
      temperature: resp['data'][0]['temp']
    }
  end

  def get_coordinates(city, state, country)
    place = city
    place += ",#{state}" if state
    place += ",#{country}" if country
    resp = JSON.parse(RestClient.get("http://api.openweathermap.org/geo/1.0/direct?q=#{place}&limit=1&appid=#{@api_key}"))
    {
      lat: resp['lat'],
      lon: resp['lon']
    }
  end
end

OpenWeather = OpenWeatherAPI.new