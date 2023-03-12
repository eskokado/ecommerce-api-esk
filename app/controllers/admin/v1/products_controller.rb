module Admin::V1
  class ProductsController < ApiController
    def index
      @products = Product.all
    end

    def create

      @product = Product.new
      @product.attributes = product_params
      save_product!
    end

    private

    def product_params
      return {} unless params.has_key?(:product)
      params.require(:product).permit(:id, :name, :description, :price, :image)
    end

    def save_product!
      @product.save!
      render json: @product, status: :created
    rescue
      render json: { errors: { fields: @product.errors.messages } }, status: :unprocessable_entity
    end

  end
end
