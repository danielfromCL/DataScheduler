class EventParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :event
  enum :status, {
    accepted: 'accepted',
    pending: 'pending',
    declined: 'declined'
  }, default: :pending
  enum :role, {
    creator: 'creator',
    participant: 'participant'
  }, default: :participant

  def schedule_conflicts
    user.events.where('events.to_date >= ? AND events.from_date <= ?', event.from_date, event.to_date).where.not(id: event.id)
  end
end
