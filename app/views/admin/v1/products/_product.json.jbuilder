json.(product, :id, :name, :description, :price, :status)
json.image product.image
json.productable product.productable_type.underscore
json.categories product.categories.pluck(:name)
