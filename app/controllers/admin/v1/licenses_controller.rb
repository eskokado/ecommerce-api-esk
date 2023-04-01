module Admin::V1
  class LicensesController < ApiController
    def index
      @licenses = License.all
    end

    def create
      @license = License.new
      @license.attributes = license_params
      save_license!
    end

    private
    def license_params
      return {} unless params.has_key?(:license)
      params.require(:license).permit(:id, :key, :game_id, :user_id)
    end

    def save_license!
      @license.save!
      render :show
    rescue
      render json: { errors: { fields: @license.errors.messages } }, status: :unprocessable_entity
    end
  end
end
