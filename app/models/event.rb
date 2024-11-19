class Event < ApplicationRecord
  has_many :event_participants
  has_many :users, through: :event_participants
  validates :from_date, presence: true
  validates :to_date, presence: true

  # Override the as_json method to include event_participants
  def as_json(options = {})
    super(options.merge(include: { event_participants: { only: [:id, :user_id, :status, :role] } }))
  end
end
