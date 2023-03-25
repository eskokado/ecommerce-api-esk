require 'rails_helper'

RSpec.describe "Admin V1 Products as :client", type: :request do
  let(:user) { create(:user, profile: :client) }

  context "GET /products" do
    let(:url) { "/admin/v1/products" }
    let!(:products) { create_list(:product, 5) }
    before(:each) { get url, headers: auth_header(user) }
    include_examples "forbidden access"
  end
end
