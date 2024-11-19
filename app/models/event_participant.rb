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
end
