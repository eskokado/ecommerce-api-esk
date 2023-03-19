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

  context "POST /coupons" do
    let(:url) { "/admin/v1/coupons" }

    context "with valid params" do
      let(:coupon_params) { { coupon: attributes_for(:coupon) }.to_json }

      it 'adds a new Coupon' do
        expect do
          post url, headers: auth_header(user), params: coupon_params
        end.to change(Coupon, :count).by(1)
      end

      it 'returns last added Coupon' do
        post url, headers: auth_header(user), params: coupon_params
        expected_coupon = Coupon.last.to_json(only: %i(id name code status discount_value max_use due_date))
        expect(response.body).to include_json(expected_coupon)
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: coupon_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:coupon_invalid_params) do
        { coupon: attributes_for(:coupon, name: nil, code: nil, status: nil, discount_value: nil, max_use: nil, due_date: nil) }.to_json
      end

      it 'does not add a new Coupon' do
        expect do
          post url, headers: auth_header(user), params: coupon_invalid_params
        end.to_not change(Coupon, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: coupon_invalid_params

        body = JSON.parse(response.body)
        expect(body['errors']['fields']).to have_key('name')
        expect(body['errors']['fields']).to have_key('code')
        expect(body['errors']['fields']).to have_key('status')
        expect(body['errors']['fields']).to have_key('discount_value')
        expect(body['errors']['fields']).to have_key('max_use')
        expect(body['errors']['fields']).to have_key('due_date')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: coupon_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
