module Admin::V1
  class GamesController < ApiController
    def index
      @games = Game.all
    end

    def create
      @game = Game.new
      @game.attributes = game_params
      save_game!
    end

    private

    def game_params
      return {} unless params.has_key?(:game)
      params.require(:game).permit(:id, :mode, :release_date, :developer, :system_requirement_id)
    end

    def save_game!
      @game.save!
      render :show
    rescue
      render json: { errors: { fields: @game.errors.messages } }, status: :unprocessable_entity
    end
  end
end
