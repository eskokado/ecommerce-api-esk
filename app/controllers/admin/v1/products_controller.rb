module Admin::V1
  class ProductsController < ApiController
    def index
      @products = Product.all
    end

    private

    def product_params
      return {} unless params.has_key?(:product)
      params.require(:product).permit(:id, :name, :description, :price)
    end

  end
end
