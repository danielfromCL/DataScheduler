require 'rails_helper'

RSpec.describe EventParticipant, type: :model do
  let!(:event) { FactoryBot.create(:event) }
  let!(:user) { FactoryBot.create(:user) }
  it 'can be created and associated with an event and user' do
    expect(EventParticipant.count).to eq 0
    expect do
      EventParticipant.create!(user:, event:, role: 'creator', status: 'accepted')
    end.not_to raise_error
    expect(EventParticipant.count).to eq 1
    event_p = EventParticipant.first
    expect(event_p.user).to eq(user)
    expect(event_p.event).to eq(event)
    expect(event_p.role).to eq('creator')
    expect(event_p.status).to eq('accepted')
    expect(event.event_participants.count).to eq 1
    expect(user.participations.count).to eq 1
    expect(event.users.first).to eq(user)
    expect(user.events.first).to eq(event)
  end
end
