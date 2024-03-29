module Admin::V1
  class UsersController < ApiController
    def index
      @users = User.all
    end

    def create
      @user = User.new
      @user.attributes = user_params
      save_user!
    end

    def update
      @user = User.find(params[:id])
      @user.attributes = user_params
      save_user!
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy!
    rescue
      render_error(fields: @user.errors.messages)
    end

    private

    def user_params
      return {} unless params.has_key?(:user)
      params.require(:user).permit(:id, :name, :email, :password, :password_confirmation, :profile)
    end

    def save_user!
      @user.save!
      render :show
    rescue
      render json: { errors: { fields: @user.errors.messages } }, status: :unprocessable_entity
    end
  end
end
