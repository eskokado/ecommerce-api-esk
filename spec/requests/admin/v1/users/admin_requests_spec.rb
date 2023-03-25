require 'rails_helper'
require "rspec-json_matchers"

RSpec.describe "Admin::V1::Users as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /users" do
    let(:url) { "/admin/v1/users" }
    let!(:users) { create_list(:user, 5) }

    it "returns all Users" do
      get url, headers: auth_header(user)
      users.append(user)
      users.sort!{|a, b| a["id"]<=>b["id"]}
      expect(response.body).to include_json(users.to_json(only: %i(id name email profile)))
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /users" do
    let(:url) { "/admin/v1/users" }

    context "with valid params" do
      let(:user_params) { { user: attributes_for(:user) }.to_json }

      it 'adds a new User' do
        expect do
          post url, headers: auth_header(user), params: user_params
        end.to change(User, :count).by(2)
      end

      it 'returns last added User' do
        post url, headers: auth_header(user), params: user_params
        expected_user = User.last.to_json(only: %i(id name email profile))
        expect(response.body).to include_json(expected_user)
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: user_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:user_invalid_params) do
        { user: attributes_for(:user, name: nil, email: nil, password: nil, password_confirmation: nil, profile: nil) }.to_json
      end

      it 'does not add a new User' do
        expect do
          post url, headers: auth_header(user), params: user_invalid_params
        end.to change(User, :count).by(1)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: user_invalid_params

        body = JSON.parse(response.body)
        expect(body['errors']['fields']).to have_key('name')
        expect(body['errors']['fields']).to have_key('email')
        expect(body['errors']['fields']).to have_key('profile')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: user_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  context "PATCH /users/:id" do
    let(:user_patch) { create(:user) }
    let(:url) { "/admin/v1/users/#{user_patch.id}" }

    context "with valid params" do
      let(:new_name) { 'My new User' }
      let(:new_email) { 'update@email.com' }
      let(:new_profile) { "client" }
      let(:user_params) { { user: { name: new_name, email: new_email, profile: new_profile } }.to_json }

      it 'updates User' do
        patch url, headers: auth_header(user), params: user_params
        user = User.find(user_patch.id)
        expect(user.name).to eq new_name
        expect(user.email).to eq new_email
        expect(user.profile).to eq new_profile
      end
    end
  end
end
