FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { Faker::Lorem.paragraph }
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) * Faker::Number.between(from: 100, to: 400) }
    image { "product_image.png" }
    status { :available }
    association :productable, factory: :game

    after :build do |product|
      product.categories << create(:category)
    end
  end
end
