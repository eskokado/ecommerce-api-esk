require 'rails_helper'
require "rspec-json_matchers"

RSpec.describe "Admin::V1::SystemRequirements as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /system_requirements" do
    let(:url) { "/admin/v1/system_requirements" }
    let!(:system_requirements) { create_list(:system_requirement, 5) }

    it "returns all SystemRequirements" do
      get url, headers: auth_header(user)

      expect(response.body).to include_json(system_requirements.to_json(only: %i(id name operational_system storage processor memory video_board)))
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /system_requirements" do
    let(:url) { "/admin/v1/system_requirements" }

    context "with valid params" do
      let(:system_requirements_params) { { system_requirement: attributes_for(:system_requirement) }.to_json }

      it 'adds a new SystemRequirements' do
        expect do
          post url, headers: auth_header(user), params: system_requirements_params
        end.to change(SystemRequirement, :count).by(1)
      end
    end
  end
end
