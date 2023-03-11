require 'rails_helper'

RSpec.describe "Admin::V1::Products as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /products" do
    let(:url) { "/admin/v1/products" }
    let!(:products) { create_list(:product, 5) }

    it "returns all Products" do
      get url, headers: auth_header(user)
      expect(body_json['products']).to contain_exactly *products.as_json(only: %i(id name description price))
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end
end

