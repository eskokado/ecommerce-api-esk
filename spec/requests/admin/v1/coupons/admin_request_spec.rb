require 'rails_helper'
require "rspec-json_matchers"

RSpec.describe "Admin::V1::Coupons as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /coupons" do
    let(:url) { "/admin/v1/coupons" }
    let!(:coupons) { create_list(:coupon, 5) }

    it "returns all Coupons" do
      get url, headers: auth_header(user)

      expect(response.body).to include_json(coupons.to_json(only: %i(id name code status discount_value max_use due_date)))
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end
end
