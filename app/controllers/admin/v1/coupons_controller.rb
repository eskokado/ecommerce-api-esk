module Admin::V1
  class CouponsController < ApiController
    def index
      @coupons = Coupon.all
    end

    def create
      @coupon = Coupon.new
      @coupon.attributes = coupon_params
      save_coupon!
    end

    def update
      @coupon = Coupon.find(params[:id])
      @coupon.attributes = coupon_params
      save_coupon!
    end

    private

    def coupon_params
      return {} unless params.has_key?(:coupon)
      params.require(:coupon).permit(:id, :name, :code, :status, :discount_value, :max_use, :due_date)
    end

    def save_coupon!
      @coupon.save!
      render :show
    rescue
      render json: { errors: { fields: @coupon.errors.messages } }, status: :unprocessable_entity
    end
  end
end
