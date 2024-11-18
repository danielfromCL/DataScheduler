require 'rails_helper'

RSpec.describe Company, type: :model do
  it 'can create a company' do
    expect(Company.count).to eq 0
    expect do
      Company.create!(identifier: '19', name: 'test')
    end.not_to raise_error
    expect(Company.count).to eq 1
  end

  it 'does not create a company if no identifier provided' do
    expect(Company.count).to eq 0
    expect do
      Company.create!(name: 'test')
    end.to raise_error ActiveRecord::RecordInvalid
    expect(Company.count).to eq 0
  end

  it 'does not allow two companies with same identifier' do
    expect(Company.count).to eq 0
    expect do
      Company.create!(identifier: '19', name: 'test')
    end.not_to raise_error
    expect(Company.count).to eq 1
    expect do
      Company.create!(identifier: '19', name: 'test')
    end.to raise_error ActiveRecord::RecordNotUnique
    expect(Company.count).to eq 1
  end
end
