require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'can create a simple event' do
    expect(Event.count).to eq 0
    expect do
      Event.create!(name: 'test', from_date: DateTime.new(2024, 11, 18, 0, 0, 0), to_date: DateTime.new(2024, 11, 18, 1, 0, 0))
    end.not_to raise_error
    expect(Event.count).to eq 1
    event = Event.first
    expect(event.name).to eq('test')
    expect(event.from_date).to eq(DateTime.new(2024, 11, 18, 0, 0, 0))
    expect(event.to_date).to eq(DateTime.new(2024, 11, 18, 1, 0, 0))
  end

  it 'does not create an event if no date range provided' do
    expect(Event.count).to eq 0
    expect do
      Event.create!(name: 'test', from_date: DateTime.new(2024, 11, 18, 0, 0, 0))
    end.to raise_error ActiveRecord::RecordInvalid
    expect do
      Event.create!(name: 'test')
    end.to raise_error ActiveRecord::RecordInvalid
    expect do
      Event.create!(name: 'test', to_date: DateTime.new(2024, 11, 18, 0, 0, 0))
    end.to raise_error ActiveRecord::RecordInvalid
    expect(Event.count).to eq 0
  end
end
