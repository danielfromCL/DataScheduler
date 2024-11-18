FactoryBot.define do
  factory :company do
    name { Faker::Company.name  }
    identifier  { Faker::ChileRut.rut }
  end

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.mail }
    identifier  { Faker::ChileRut.rut }
    role { 'member' }
  end
end