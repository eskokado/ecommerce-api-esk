require 'rails_helper'
require 'json_spec'

RSpec.describe "Admin V1 Products as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /products" do
    let(:url) { "/admin/v1/products" }
    let!(:categories) { create_list(:category, 2) }
    let!(:products) { create_list(:product, 10, categories: categories) }

    context "without any params" do
      it "returns 10 records" do
        get url, headers: auth_header(user)
        expect(JSON.parse(response.body).count).to eq 10
      end

    end
  end
end
