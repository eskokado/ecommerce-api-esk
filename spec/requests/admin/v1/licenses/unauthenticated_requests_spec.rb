require 'rails_helper'

RSpec.describe "Admin V1 Licenses without authentication", type: :request do
  let(:user) { create(:user) }

  context "GET /licenses" do
    let(:url) { "/admin/v1/licenses" }
    let!(:licenses) { create_list(:license, 5) }
    before(:each) { get url }
    include_examples "unauthenticated access"
  end
end
