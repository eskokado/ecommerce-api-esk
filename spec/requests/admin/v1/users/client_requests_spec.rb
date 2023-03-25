require 'rails_helper'

RSpec.describe "Admin V1 Users as :client", type: :request do
  let(:user) { create(:user, profile: :client) }

  context "GET /users" do
    let(:url) { "/admin/v1/users" }
    let!(:users) { create_list(:user, 5) }
    before(:each) { get url, headers: auth_header(user) }
    include_examples "forbidden access"
  end

end
