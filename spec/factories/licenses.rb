FactoryBot.define do
  factory :license do
    key { Faker::Alphanumeric.alpha(number: 10) }
    platform { %i(steam battle_net origin).sample }
    status { %i(available in_use inative).sample }
    association :user
    association :game
  end
end
