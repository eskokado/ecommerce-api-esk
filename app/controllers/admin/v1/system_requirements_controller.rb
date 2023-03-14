module Admin::V1
  class SystemRequirementsController < ApiController
    def index
      @system_requirements = SystemRequirement.all
    end

    def create
      @system_requirements = SystemRequirement.new
      @system_requirements.attributes = system_requirements_params
      @system_requirements.save!
      render :show
    rescue
      render json: { errors: { fields: @category.errors.messages } }, status: :unprocessable_entity
    end

    private

    def system_requirements_params
      return {} unless params.has_key?(:system_requirement)
      params.require(:system_requirement).permit(:id, :name, :operational_system, :storage, :processor, :memory, :video_board)
    end
  end
end
