require 'rails_helper'
require "rspec-json_matchers"

RSpec.describe "Admin::V1::Games as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /games" do
    let(:url) { "/admin/v1/games" }
    let!(:games) { create_list(:game, 5) }

    it "returns all Games" do
      get url, headers: auth_header(user)

      expect(response.body).to include_json(games.to_json(only: %i(id mode release_date developer)))
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /games" do
    let(:url) { "/admin/v1/games" }

    context "with valid params" do
      let(:system_requirement) { create(:system_requirement)}
      let(:game_params) { { game: attributes_for(:game, system_requirement_id: system_requirement.id) }.to_json }

      it 'adds a new Game' do
        expect do
          post url, headers: auth_header(user), params: game_params
        end.to change(Game, :count).by(1)
      end

      it 'returns last added Game' do
        post url, headers: auth_header(user), params: game_params
        expected_game = Game.last.to_json(only: %i(id mode release_date developer system_requirement_id))
        expect(response.body).to include_json(expected_game)
      end
    end
  end
end
