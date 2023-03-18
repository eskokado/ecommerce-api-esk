module Admin::V1
  class GamesController < ApiController
    def index
      @games = Game.all
    end
  end
end
