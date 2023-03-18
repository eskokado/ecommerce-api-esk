require 'rails_helper'

RSpec.describe "Admin V1 Games without authentication", type: :request do
  let(:user) { create(:user) }

  context "GET /games" do
    let(:url) { "/admin/v1/games" }
    let!(:games) { create_list(:game, 5) }
    before(:each) { get url }
    include_examples "unauthenticated access"
  end

  context "POST /games" do
    let(:url) { "/admin/v1/games" }
    before(:each) { post url }
    include_examples "unauthenticated access"
  end

  context "PATCH /games/:id" do
    let(:game) { create(:game) }
    let(:url) { "/admin/v1/games/#{game.id}" }
    before(:each) { patch url }
    include_examples "unauthenticated access"
  end

  context "DELETE /games/:id" do
    let!(:game) { create(:game) }
    let(:url) { "/admin/v1/games/#{game.id}" }
    before(:each) { delete url }
    include_examples "unauthenticated access"
  end
end
