class Event < ApplicationRecord
  has_many :event_participants
  validates :from_date, presence: true
  validates :to_date, presence: true
end
