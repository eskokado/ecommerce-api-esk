module Admin::V1
  class CategoriesController < ApplicationController
    def index
      @categories = Category.all
    end

    def create
      @category = Category.new
      @category.attributes = category_params
      save_category!
    end

    private

    def category_params
      return {} unless params.has_key?(:category)
      params.require(:category).permit(:id, :name)
    end

    def save_category!
      @category.save!
      render :show
    rescue
      render json: { errors: { fields: @category.errors.messages } }, status: :unprocessable_entity
      # Admin::V1::ApiController.render_error(message: @category.errors.messages, fields: @category.errors.details)
    end

  end

end
