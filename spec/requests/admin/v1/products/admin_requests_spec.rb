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

    context "with search[name] param" do
      let!(:search_name_products) do
        products = []
        15.times { |n| products << create(:product, name: "Search #{n + 1}") }
        products
      end

      let(:search_params) { { search: { name: "Search" } } }

      it "returns only seached products limited by default pagination" do
        get url, headers: auth_header(user), params: search_params
        expected_return = search_name_products[0..9].map do |product|
          build_game_product_json(product)
        end
        expect(JSON.parse(response.body).map { |product| product.except("system_requirement").slice("id", "name", "description", "price", "status", "featured", "productable", "productable_id", "categories") }).to match_array(expected_return.map { |product| product.except("system_requirement").slice("id", "name", "description", "price", "status", "featured", "productable", "productable_id", "categories") })
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: search_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with pagination params" do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it "returns records sized by :length" do
        get url, headers: auth_header(user), params: pagination_params
        expect(JSON.parse(response.body).count).to eq length
      end

      it "returns products limited by pagination" do
        get url, headers: auth_header(user), params: pagination_params
        expected_return = products[5..9].map do |product|
          build_game_product_json(product)
        end
        expect(JSON.parse(response.body).map { |product| product.except("system_requirement").slice("id", "name", "description", "price", "status", "featured", "productable", "productable_id", "categories") }).to match_array(expected_return.map { |product| product.except("system_requirement").slice("id", "name", "description", "price", "status", "featured", "productable", "productable_id", "categories") })
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: pagination_params
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
