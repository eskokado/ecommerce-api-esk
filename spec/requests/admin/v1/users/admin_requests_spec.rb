require 'rails_helper'
require "rspec-json_matchers"

RSpec.describe "Admin::V1::Users as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /users" do
    let(:url) { "/admin/v1/users" }
    let!(:users) { create_list(:user, 5) }

    it "returns all Users" do
      get url, headers: auth_header(user)
      users.append(user)
      users.sort!{|a, b| a["id"]<=>b["id"]}
      expect(response.body).to include_json(users.to_json(only: %i(id name email profile)))
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end
end
