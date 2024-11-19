class Event < ApplicationRecord
  has_many :event_participants
  has_many :users, through: :event_participants
  validates :from_date, presence: true
  validates :to_date, presence: true

  def weather
    return if online || !city
    OpenWeather.get_weather(city, state, country, from_date)
  end
end
