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
end
