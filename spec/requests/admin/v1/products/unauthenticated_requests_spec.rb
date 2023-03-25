require 'rails_helper'

RSpec.describe "Admin V1 Products without authentication", type: :request do
  let(:user) { create(:user) }

  context "GET /products" do
    let(:url) { "/admin/v1/products" }
    let!(:products) { create_list(:product, 5) }
    before(:each) { get url }
    include_examples "unauthenticated access"
  end

  context "POST /products" do
    let(:url) { "/admin/v1/products" }
    before(:each) { post url }
    include_examples "unauthenticated access"
  end

  context "PATCH /products/:id" do
    let(:product) { create(:product) }
    let(:url) { "/admin/v1/products/#{product.id}" }
    before(:each) { patch url }
    include_examples "unauthenticated access"
  end
end
