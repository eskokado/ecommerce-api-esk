FactoryBot.define do
  factory :license do
    key { Faker::Number.between(from: 5000, to: 10000) }
    association :user
    association :game
  end
end
