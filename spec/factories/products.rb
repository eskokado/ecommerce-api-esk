FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { Faker::Lorem.paragraph }
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) * Faker::Number.between(from: 100, to: 400) }
    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/support/images/product_image.png")) }
    status { :available }
    featured { false }


    after :build do |product|
      product.productable ||= create(:game)
      product.categories ||= create_list(:category, 2)
    end
  end
end
