class EventParticipant < ApplicationRecord
  include SendGrid
  belongs_to :user
  belongs_to :event
  after_create :notify_event
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

  private

  def notify_event
    from = SendGrid::Email.new(email: 'datascheduler@dscope.com', name: "DataScheduler")
    to = SendGrid::Email.new(email: user.email, name: user.name)
    subject = 'New event scheduled'
    text = "An event has been scheduled.
        Date: #{event.from_date.to_formatted_s(:short)}-#{event.to_date.to_formatted_s(:short)}"
    text += "\nLocation: #{event.city} - #{event.country}" unless event.online || event.city.nil?
    text += "\nMeeting link: #{event.url}" if event.online && event.url
    content = SendGrid::Content.new(
      type: 'text/html',
      value: text
    )
    Sendgrid.send_email(from, to, subject, content)
  end
end
