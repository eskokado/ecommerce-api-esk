require 'rails_helper'
require 'json_spec'

RSpec.describe "Admin V1 Products as :admin", type: :request do
  let(:user) { create(:user) }
  let!(:categories) { create_list(:category, 2) }
  let!(:game) { create(:game) }
  let!(:products) { create_list(:product, 10, categories: categories, productable: game) }

  context "GET /products" do
    let(:url) { "/admin/v1/products" }

    context "without any params" do
      before(:each) do
        get url, headers: auth_header(user)
      end

      it "returns 10 records" do
        expect(JSON.parse(response.body).count).to eq 10
      end

      it "returns Products with :productable following the default pagination" do
        expected_products = products[0..9].map { |product| build_game_product_json(product) }
        expect(JSON.parse(response.body).map { |product| product.except("system_requirement").slice("id", "name", "description", "price", "status", "featured", "productable", "productable_id", "categories") }).to match_array(expected_products.map { |product| product.except("system_requirement").slice("id", "name", "description", "price", "status", "featured", "productable", "productable_id", "categories") })
      end

      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

def build_game_product_json(product)
  json = product.as_json(only: %i(id name description price status))
  json['productable'] = product.productable.as_json(only: %i(id mode release_date developer))
  json['categories'] = product.categories.map { |category| category.as_json(only: %i(id name)) }
  json
end
