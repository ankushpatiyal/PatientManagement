FactoryBot.define do
  factory :patient do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    date_of_birth { Faker::Date.backward(days: 365) }
    next_appointment { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default) }
  end
end
