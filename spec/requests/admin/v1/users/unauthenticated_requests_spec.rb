require 'rails_helper'

RSpec.describe "Admin V1 Users without authentication", type: :request do
  let(:user) { create(:user) }

  context "GET /users" do
    let(:url) { "/admin/v1/users" }
    let!(:users) { create_list(:user, 5) }
    before(:each) { get url }
    include_examples "unauthenticated access"
  end

  context "POST /users" do
    let(:url) { "/admin/v1/users" }
    before(:each) { post url }
    include_examples "unauthenticated access"
  end

  context "PATCH /user/:id" do
    let(:user_patch) { create(:user) }
    let(:url) { "/admin/v1/users/#{user_patch.id}" }
    before(:each) { patch url }
    include_examples "unauthenticated access"
  end
end
