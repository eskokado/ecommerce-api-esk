FactoryBot.define do
  factory :game do
    mode { %i(pvp pve both).sample }
    release_date { Faker::Date.between(from: '2023-01-01', to: '2023-03-18') }
    developer { Faker::Name.name }
    system_requirement
  end
end
