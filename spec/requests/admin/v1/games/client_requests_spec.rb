require 'rails_helper'

RSpec.describe "Admin V1 Games as :client", type: :request do
  let(:user) { create(:user, profile: :client) }

  context "GET /games" do
    let(:url) { "/admin/v1/games" }
    let!(:games) { create_list(:game, 5) }
    before(:each) { get url, headers: auth_header(user) }
    include_examples "forbidden access"
  end

  context "POST /games" do
    let(:url) { "/admin/v1/games" }
    before(:each) { post url, headers: auth_header(user) }
    include_examples "forbidden access"
  end

  context "PATCH /games/:id" do
    let(:game) { create(:game) }
    let(:url) { "/admin/v1/games/#{game.id}" }
    before(:each) { patch url, headers: auth_header(user) }
    include_examples "forbidden access"
  end

  context "DELETE /games/:id" do
    let!(:game) { create(:game) }
    let(:url) { "/admin/v1/games/#{game.id}" }
    before(:each) { delete url, headers: auth_header(user) }
    include_examples "forbidden access"
  end
end
