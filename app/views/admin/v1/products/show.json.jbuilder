json.product do
  json.extract! @product, :id, :name, :description, :price

  json.image_url url_for(@product.image) if @product.image.attached?

  json.productable do
    if @product.productable_type == "Game"
      json.extract! @product.productable, :id, :mode, :release_date, :developer
    end
  end

  json.categories do
    json.array! @product.categories, :id, :name
  end
end
