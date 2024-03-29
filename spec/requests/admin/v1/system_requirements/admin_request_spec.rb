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

      it 'returns updated SystemRequirement' do
        patch url, headers: auth_header(user), params: system_requirement_params
        system_requirement.reload
        expected_system_requirement = SystemRequirement.last.to_json(only: %i(id name operational_system storage processor memory video_board))
        expect(response.body).to include_json(expected_system_requirement)
      end

      it 'returns success status' do
        patch url, headers: auth_header(user), params: system_requirement_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:system_requirement_invalid_params) {
        { system_requirement:
            {
              name: nil,
              operational_system: nil,
              storage: nil,
              processor: nil,
              memory: nil,
              video_board: nil
            }
        }.to_json
      }

      it 'does not update SystemRequirement' do
        old_name = system_requirement.name
        old_operational_system = system_requirement.operational_system
        old_storage = system_requirement.storage
        old_processor = system_requirement.processor
        old_memory = system_requirement.memory
        old_video_board = system_requirement.video_board
        patch url, headers: auth_header(user), params: system_requirement_invalid_params
        system_requirement.reload
        expect(system_requirement.name).to eq old_name
        expect(system_requirement.operational_system).to eq old_operational_system
        expect(system_requirement.storage).to eq old_storage
        expect(system_requirement.processor).to eq old_processor
        expect(system_requirement.memory).to eq old_memory
        expect(system_requirement.video_board).to eq old_video_board
      end

      it 'returns error message' do
        patch url, headers: auth_header(user), params: system_requirement_invalid_params
        body = JSON.parse(response.body)
        expect(body['errors']['fields']).to have_key('name')
        expect(body['errors']['fields']).to have_key('operational_system')
        expect(body['errors']['fields']).to have_key('storage')
        expect(body['errors']['fields']).to have_key('processor')
        expect(body['errors']['fields']).to have_key('memory')
        expect(body['errors']['fields']).to have_key('video_board')
      end

      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "DELETE /system_requirements/:id" do
      let!(:system_requirement) { create(:system_requirement) }
      let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

      it 'removes SystemRequirement' do
        expect do
          delete url, headers: auth_header(user)
        end.to change(SystemRequirement, :count).by(-1)
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
end
