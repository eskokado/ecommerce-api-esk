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
          productable: { only: %i(id mode release_date developer) },
          categories: { only: %i(id name) }
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
      let(:game) { create(:game) }
      let(:product_params) { { product: attributes_for(:product, productable_id: game.id, productable_type: "Game") }.to_json }

      it 'adds a new Product' do
        expect do
          post url, headers: auth_header(user), params: product_params
        end.to change(Product, :count).by(1)
      end

      it 'returns last added Product' do
        post url, headers: auth_header(user), params: product_params
        expected_product = { product: Product.last.reload.as_json(
          only: %i[id name description price image],
          include: { productable: { only: %i[id mode release_date developer] }, categories: { only: %i[id name] } }
        ) }.stringify_keys
        expect(JSON.parse(response.body)).to eq(expected_product)
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: product_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:product_invalid_params) do
        { product: attributes_for(
            :product,
            name: nil,
            description: nil,
            price: nil,
            image: nil
          )
        }.to_json
      end

      it 'does not add a new Product' do
        expect do
          post url, headers: auth_header(user), params: product_invalid_params
        end.to_not change(Product, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: product_invalid_params

        body = JSON.parse(response.body)
        expect(body['errors']['fields']).to have_key('name')
        expect(body['errors']['fields']).to have_key('description')
        expect(body['errors']['fields']).to have_key('price')
        expect(body['errors']['fields']).to have_key('image')
        expect(body['errors']['fields']).to have_key('productable')
      end
    end
  end
end
