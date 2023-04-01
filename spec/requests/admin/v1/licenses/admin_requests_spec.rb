require 'rails_helper'
require "rspec-json_matchers"

RSpec.describe "Admin::V1::Licenses as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /licenses" do
    let(:url) { "/admin/v1/licenses" }
    let!(:licenses) { create_list(:license, 10) }

    it "returns 10 Licenses" do
      get url, headers: auth_header(user)
      expect(body_json['licenses'].count).to eq 10
    end

    it "returns 10 first Licenses" do
      get url, headers: auth_header(user)
      expected_licenses = licenses[0..9].as_json(only: %i(id key game_id user_id))
      expect(body_json['licenses']).to match_array expected_licenses
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /licenses" do
    let(:url) { "/admin/v1/licenses" }

    context "with valid params" do
      let(:user) { create(:user) }
      let(:game) { create(:game) }
      let(:license_params) { { license: attributes_for(:license).merge(user_id: user.id, game_id: game.id) }.to_json }

      it 'adds a new License' do
        expect do
          post url, headers: auth_header(user), params: license_params
        end.to change(License, :count).by(1)
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)
      end

    end

    context "with invalid params" do
      let(:license_invalid_params) do
        { license: attributes_for(:license, key: nil) }.to_json
      end

      it 'does not add a new Licence' do
        expect do
          post url, headers: auth_header(user), params: license_invalid_params
        end.to_not change(License, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: license_invalid_params

        body = JSON.parse(response.body)
        expect(body['errors']['fields']).to have_key('key')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end

end
