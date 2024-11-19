FactoryBot.define do
  factory :company do
    name { Faker::Company.name  }
    identifier  { Faker::ChileRut.rut }
  end

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    identifier  { Faker::ChileRut.rut }
    role { 'member' }
  end

  factory :event do
    name { 'Test Event' }
    from_date { Faker::Time.between_dates(from: Date.today - 2, to: Date.today) }
    to_date { DateTime.now }
  end

  factory :event_participant do
    status { 'pending' }
    role { 'participant' }
  end
end