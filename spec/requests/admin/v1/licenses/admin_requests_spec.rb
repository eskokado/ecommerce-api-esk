require 'rails_helper'
require "rspec-json_matchers"

RSpec.describe "Admin::V1::Licenses as :admin", type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }

  context "GET /games/:game_id/licenses" do
    let(:url) { "/admin/v1/games/#{game.id}/licenses" }
    let!(:licenses) { create_list(:license, 10, game: game, user: user) }

    context "without any params" do
      it "returns 10 Licenses" do
        get url, headers: auth_header(user)
        expect(body_json['licenses'].count).to eq 10
      end

      it "returns 10 first Licenses" do
        get url, headers: auth_header(user)
        expected_licenses = licenses[0..9].as_json(only: %i(id key platform status game_id user_id))
        expect(body_json['licenses']).to match_array expected_licenses
      end
      it "returns success status" do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user) }
      end
    end

    context "with search[key] param" do
        let!(:search_key_licenses) do
          licenses = []
          15.times { |n| licenses << create(:license, key: "SRC#{n + 1}", game: game) }
          licenses
        end

        let(:search_params) { { search: { key: "SRC" } } }

        it "returns only seached licenses limited by default pagination" do
          get url, headers: auth_header(user), params: search_params
          expected_licenses = search_key_licenses[0..9].map do |license|
            license.as_json(only: %i(id key platform status game_id user_id))
          end
          expect(body_json['licenses']).to match_array expected_licenses
        end

        it "returns success status" do
          get url, headers: auth_header(user), params: search_params
          expect(response).to have_http_status(:ok)
        end

        it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 15, total_pages: 2 } do
          before { get url, headers: auth_header(user), params: search_params }
        end
    end

    context "with pagination params" do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it "returns records sized by :length" do
        get url, headers: auth_header(user), params: pagination_params
        expect(body_json['licenses'].count).to eq length
      end
    end
  end

  context "POST /games/:game_id/licenses" do
    let(:url) { "/admin/v1/games/#{game.id}/licenses" }

    context "with valid params" do
      let(:user) { create(:user) }
      let(:game) { create(:game) }
      let(:license_params) { { license: attributes_for(:license).merge(user_id: user.id, game_id: game.id) }.to_json }

      it 'adds a new License' do
        expect do
          post url, headers: auth_header(user), params: license_params
        end.to change(License, :count).by(1)
      end

      it 'returns last added License' do
        post url, headers: auth_header(user), params: license_params
        expected_license = License.last.as_json(only: %i(id key platform status game_id user_id))
        expect(body_json['license']).to match_array expected_license
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

  context "GET /licenses/:id" do
    let(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    it "returns requested License" do
      get url, headers: auth_header(user)
      expected_license = license.as_json(only: %i(id key platform status game_id user_id))
      expect(body_json['license']).to match_array expected_license
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "PATCH /licenses/:id" do
    let(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    context "with valid params" do
      let(:user) { create(:user) }
      let(:game) { create(:game) }
      let(:new_key) { 'new key' }
      let(:license_params) { { license: attributes_for(:license, key: new_key).merge(user_id: user.id, game_id: game.id) }.to_json }

      it 'updates License' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expect(license.key).to eq new_key
        expect(license.game_id).to eq game.id
        expect(license.user_id).to eq user.id
      end

      it 'returns updated License' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expected_license = license.as_json(only: %i(id key platform status game_id user_id))
        body = JSON.parse(response.body)
        expect(body['license']).to match_array expected_license
      end

      it 'returns success status' do
        patch url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:license_invalid_params) do
        { license: attributes_for(:license, key: nil) }.to_json
      end

      it 'does not update License' do
        old_key = Faker::Alphanumeric.alpha(number: 10)
        old_platform = %i(steam battle_net origin).sample
        old_status = %i(available in_use inative).sample
        old_user = create(:user)
        old_game = create(:game)
        license = License.create!(key: old_key, platform: old_platform, status: old_status, user_id: old_user.id, game_id: old_game.id)

        patch url, headers: auth_header(user), params: license_invalid_params
        license.reload

        expect(license.key).to eq old_key
        expect(license.platform.to_s).to eq old_platform.to_s
        expect(license.status.to_s).to eq old_status.to_s
        expect(license.user_id).to eq old_user.id
        expect(license.game_id).to eq old_game.id
      end

      it 'returns error message' do
        patch url, headers: auth_header(user), params: license_invalid_params
        body = JSON.parse(response.body)
        expect(body['errors']['fields']).to have_key('key')
      end

      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "DELETE /licenses/:id" do
    let!(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    it 'removes License' do
      expect do
        delete url, headers: auth_header(user)
      end.to change(License, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end

  end
end
