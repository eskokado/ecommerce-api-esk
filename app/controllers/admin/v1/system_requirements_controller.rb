module Admin::V1
  class SystemRequirementsController < ApiController
    def index
      @system_requirements = SystemRequirement.all
    end

    def create
      @system_requirement = SystemRequirement.new
      @system_requirement.attributes = system_requirement_params
      save_system_requirement!
    end

    def update
      @system_requirement = SystemRequirement.find(params[:id])
      @system_requirement.attributes = system_requirement_params
      save_system_requirement!
    end

    def destroy
      @system_requirement = SystemRequirement.find(params[:id])
      @system_requirement.destroy!
    rescue
      render_error(fields: @category.errors.messages)
    end

    private

    def system_requirement_params
      return {} unless params.has_key?(:system_requirement)
      params.require(:system_requirement).permit(:id, :name, :operational_system, :storage, :processor, :memory, :video_board)
    end

    def save_system_requirement!
      @system_requirement.save!
      render :show
    rescue
      render json: { errors: { fields: @system_requirement.errors.messages } }, status: :unprocessable_entity
    end
  end
end
