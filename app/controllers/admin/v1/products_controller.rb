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

    # def product_params
    #   params.require(:product).permit(:name, :description, :price, :image, category_ids: [], game_attributes: [:id, :mode, :release_date, :developer])
    # end

    def product_params
      params.require(:product).permit(:name, :description, :price, :image, :productable_type, productable_attributes: [:mode, :release_date, :developer], category_ids: [])
    end

    def save_product!
      @product.save!
      render :show
    rescue
      render json: { errors: { fields: @product.errors.messages } }, status: :unprocessable_entity
    end
  end
end