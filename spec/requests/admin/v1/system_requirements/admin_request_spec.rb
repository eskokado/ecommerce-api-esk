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
      let(:system_requirement_params) { { system_requirement: attributes_for(:system_requirement) }.to_json }

      it 'adds a new SystemRequirement' do
        expect do
          post url, headers: auth_header(user), params: system_requirement_params
        end.to change(SystemRequirement, :count).by(1)
      end


      it 'returns last added SystemRequirement' do
        post url, headers: auth_header(user), params: system_requirement_params
        expected_system_requirement = SystemRequirement.last.to_json(only: %i(id name operational_system storage processor memory video_board))
        expect(response.body).to include_json(expected_system_requirement)
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: system_requirement_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:system_requirement_invalid_params) do
        { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json
      end

      it 'does not add a new SystemRequirements' do
        expect do
          post url, headers: auth_header(user), params: system_requirement_invalid_params
        end.to_not change(SystemRequirement, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: system_requirement_invalid_params

        body = JSON.parse(response.body)
        expect(body['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "PATCH /system_requirements/:id" do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    context "with valid params" do
      let(:new_name) { 'My new SystemRequirement' }
      let(:new_operational_system) { Faker::Computer.os }
      let(:new_storage) { "6GB" }
      let(:new_processor) { "AMD Ryzen 9" }
      let(:new_memory) { "4GB" }
      let(:new_video_board) { "N/S" }
      let(:system_requirement_params) {
        { system_requirement:
            {
              name: new_name,
              operational_system: new_operational_system,
              storage: new_storage,
              processor: new_processor,
              memory: new_memory,
              video_board: new_video_board
            }
        }.to_json
      }

      it 'updates SystemRequirement' do
        patch url, headers: auth_header(user), params: system_requirement_params
        system_requirement.reload
        expect(system_requirement.name).to eq new_name
        expect(system_requirement.operational_system).to eq new_operational_system
        expect(system_requirement.storage).to eq new_storage
        expect(system_requirement.processor).to eq new_processor
        expect(system_requirement.memory).to eq new_memory
        expect(system_requirement.video_board).to eq new_video_board
      end
    end
  end
end
