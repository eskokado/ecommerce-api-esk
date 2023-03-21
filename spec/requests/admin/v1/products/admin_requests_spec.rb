require 'rails_helper'
require 'json_spec'

RSpec.describe "Admin::V1::Products as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /products" do
    let(:url) { "/admin/v1/products" }
    let!(:products) { create_list(:product, 5) }

    it "returns all Products" do
      get url, headers: auth_header(user)

      expected_response = products.as_json(
        only: %i(id name description price image),
        include: {
          productable: { only: %i(id mode release_date developer)},
          categories: { only: %i(id name)}
        }
      )

      expect(response.headers['Content-Type']).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to be_an(Array)
      expect(JSON.parse(response.body)).not_to be_empty

      # Testa os campos do primeiro item do array
      first_item = JSON.parse(response.body).first
      expect(first_item).to have_key('id')
      expect(first_item).to have_key('name')
      expect(first_item).to have_key('productable')
      expect(first_item).to have_key('categories')

      # Verifica se o campo 'productable' é um hash que contém as chaves 'id' e 'mode'
      expect(first_item['productable']).to be_a(Hash)
      expect(first_item['productable']).to have_key('id')
      expect(first_item['productable']).to have_key('mode')

      # Verifica se o campo 'categories' é um array de hashes
      expect(first_item['categories']).to be_an(Array)
      expect(first_item['categories']).not_to be_empty

      # Verifica se o primeiro item do array de 'categories' contém as chaves 'id' e 'name'
      expect(first_item['categories'].first).to have_key('id')
      expect(first_item['categories'].first).to have_key('name')
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /products" do
    let(:url) { "/admin/v1/products" }

    context "with valid params" do
      let(:product_params) { { product: attributes_for(:product) }.to_json }

      it 'adds a new Product' do
        expect do
          post url, headers: auth_header(user), params: product_params
        end.to change(Product, :count).by(1)
      end

      it 'returns last added Product' do
        post url, headers: auth_header(user), params: product_params
        expected_product = Product.last.to_json(
          only: %i[id name description price],
          include: { game: { only: %i[id mode release_date developer] }, categories: { only: %i[id name] } }
        )
        expect(response.body).to include_json(expected_product)
      end
    end

    it 'returns success status' do
      post url, headers: auth_header(user), params: product_params
      expect(response).to have_http_status(:ok)
    end
  end
end
