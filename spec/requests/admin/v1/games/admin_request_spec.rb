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

      it 'returns success status' do
        post url, headers: auth_header(user), params: game_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:game_invalid_params) do
        { game: attributes_for(:game, mode: nil, release_date: nil, developer: nil, system_requirement_id: nil) }.to_json
      end

      it 'does not add a new Game' do
        expect do
          post url, headers: auth_header(user), params: game_invalid_params
        end.to_not change(Game, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: game_invalid_params

        expect(response.body).to include("é obrigatório" || "não pode ficar em branco")
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: game_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "PATCH /games/:id" do
    let(:game) { create(:game) }
    let(:url) { "/admin/v1/games/#{game.id}" }

    context "with valid params" do
      let(:new_system_requirement) { create(:system_requirement)}
      let(:new_release_date) { Faker::Date.between(from: '2023-01-01', to: '2023-03-18') }
      let(:new_developer) { Faker::Name.name }

      let(:game_params) {
        { game:
            {
              release_date: new_release_date,
              developer: new_developer,
              system_requirement_id: new_system_requirement.id
            }
        }.to_json
      }

      it 'updates Game' do
        patch url, headers: auth_header(user), params: game_params
        game.reload
        expect(game.release_date).to eq new_release_date
        expect(game.developer).to eq new_developer
        expect(game.system_requirement).to eq new_system_requirement
      end
    end
  end
end
