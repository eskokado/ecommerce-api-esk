json.products do
  json.array! @products, :id, :name, :description, :price
end
