require 'rails_helper'

RSpec.describe "Admin V1 Licenses as :client", type: :request do
  let(:user) { create(:user, profile: :client) }

  context "GET /licenses" do
    let(:url) { "/admin/v1/licenses" }
    let!(:licenses) { create_list(:license, 5) }
    before(:each) { get url, headers: auth_header(user) }
    include_examples "forbidden access"
  end
end
