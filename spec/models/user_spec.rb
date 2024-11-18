require 'rails_helper'

RSpec.describe User, type: :model do
  it 'can create a user' do
    expect(User.count).to eq 0
    expect do
      User.create!(identifier: '19', name: 'test')
    end.not_to raise_error
    expect(User.count).to eq 1
  end

  it 'does not create a user if no identifier provided' do
    expect(User.count).to eq 0
    expect do
      User.create!(name: 'test')
    end.to raise_error ActiveRecord::RecordInvalid
    expect(User.count).to eq 0
  end

  it 'does not allow two users with same identifier' do
    expect(User.count).to eq 0
    expect do
      User.create!(identifier: '19', name: 'test')
    end.not_to raise_error
    expect(User.count).to eq 1
    expect do
      User.create!(identifier: '19', name: 'test')
    end.to raise_error ActiveRecord::RecordNotUnique
    expect(User.count).to eq 1
  end

  context 'associating with a company' do
    let!(:company) { FactoryBot.create(:company) }

    it 'creates a member user' do
      expect do
        User.create!(name: 'test', identifier: '19', email: 'a@a.com', company:, role: 'member')
      end.not_to raise_error
      expect(company.users.count).to eq 1
      expect(company.users.first.email).to eq('a@a.com')
      expect(company.users.first.role).to eq('member')
    end

    it 'creates an owner user' do
      expect do
        User.create!(name: 'test', identifier: '19', email: 'a@a.com', company:, role: 'owner')
      end.not_to raise_error
      expect(company.users.count).to eq 1
      expect(company.users.first.email).to eq('a@a.com')
      expect(company.users.first.role).to eq('owner')
    end

    it 'fails if role non-existent' do
      expect do
        User.create!(name: 'test', identifier: '19', email: 'a@a.com', company:, role: 'not_a_role')
      end.to raise_error ArgumentError
    end
  end
end
