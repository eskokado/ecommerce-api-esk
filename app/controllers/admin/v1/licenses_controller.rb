module Admin::V1
  class LicensesController < ApiController
    before_action :load_license, only: [:show, :update, :destroy]
    def index
      @licenses = License.all
    end

    def create
      @license = License.new
      @license.attributes = license_params
      save_license!
    end

    def show
    end
    def update
      @license.attributes = license_params
      save_license!
    end

    def destroy
      @license.destroy!
    rescue
      render_error(fields: @license.errors.messages)
    end

    private
    def load_license
      @license = License.find(params[:id])
    end
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
