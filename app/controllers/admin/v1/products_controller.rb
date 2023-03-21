module Admin::V1
  class ProductsController < ApiController
    def index
      @products = Product.all
    end
  end
end
