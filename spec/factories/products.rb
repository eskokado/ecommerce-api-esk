FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 100.0..400.0) }
    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/support/images/product_image.png")) }
    association :productable, factory: :game

    after :build do |product|
      product.categories << create(:category)
    end
  end
end
