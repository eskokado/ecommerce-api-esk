# json.products do
#   json.array! @loading_service.records do |product|
# end
json.products do
  json.array! @loading_service.records do |product|
    json.extract! product, :id, :name, :description, :price, :image, :status, :featured

    json.productable do
      if product.productable_type == "Game"
        json.extract! product.productable, :id, :mode, :release_date, :developer
      end
    end

    json.categories do
      json.array! product.categories, :id, :name
    end
  end
end

json.meta do
  json.partial! 'shared/pagination', pagination: @loading_service.pagination
end
