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

  context "PATCH /coupons/:id" do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }

    context "with valid params" do
      let(:new_name) { 'My new Coupon' }
      let(:new_code) { Faker::Commerce.unique.promotion_code(digits: 4) }
      let(:new_status) { :active }
      let(:new_discount_value) { 25 }
      let(:new_max_use) { 3 }
      let(:new_due_date) { 3.days.from_now }

      let(:coupon_params) { { coupon: {
        name: new_name,
        code: new_code,
        status: new_status,
        discount_value: new_discount_value,
        max_use: new_max_use,
        due_date: new_due_date
      } }.to_json }

      it 'updates Coupon' do
        patch url, headers: auth_header(user), params: coupon_params
        coupon.reload
        expect(coupon.name).to eq new_name
        expect(coupon.code).to eq new_code
        expect(coupon.status).to eq new_status.as_json
        expect(coupon.discount_value).to eq new_discount_value
        expect(coupon.max_use).to eq new_max_use
        expect(coupon.due_date.as_json).to eq new_due_date.as_json
      end

      it 'returns updated Coupon' do
        patch url, headers: auth_header(user), params: coupon_params
        coupon.reload
        expected_coupon = coupon.as_json(only: %i(id name code status discount_value max_use due_date))
        body = JSON.parse(response.body)
        expect(body['coupon']).to eq expected_coupon
      end

      it 'returns success status' do
        patch url, headers: auth_header(user), params: coupon_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:coupon_invalid_params) do
        { coupon: attributes_for(:coupon, name: nil, code: nil, status: nil, discount_value: nil, max_use: nil, due_date: nil) }.to_json
      end

      it 'does not update Coupon' do
        old_name = coupon.name
        old_code = coupon.code
        old_status = coupon.status
        old_discount_value = coupon.discount_value
        old_max_use = coupon.max_use
        old_due_date = coupon.due_date
        patch url, headers: auth_header(user), params: coupon_invalid_params
        coupon.reload
        expect(coupon.name).to eq old_name
        expect(coupon.code).to eq old_code
        expect(coupon.status).to eq old_status
        expect(coupon.discount_value).to eq old_discount_value
        expect(coupon.max_use).to eq old_max_use
        expect(coupon.due_date.as_json).to eq old_due_date.as_json
      end
    end
  end
end
