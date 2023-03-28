# json.products do
#   json.array! @products do |product|
#     json.partial! product
#     json.partial! product.productable
#   end
# end
json.array! @products do |product|
  json.extract! product, :id, :name, :description, :price, :image, :status

  json.productable do
    if product.productable_type == "Game"
      json.extract! product.productable, :id, :mode, :release_date, :developer
    end
  end

  json.categories do
    json.array! product.categories, :id, :name
  end
end
